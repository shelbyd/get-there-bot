require 'net/irc'
require 'redis'
Dir["./lib/*.rb"].each {|file| require file }

class Client < Net::IRC::Client
  attr_accessor :meta_channel

  def method_missing(m, *args, &block)
    raise NoMethodError.new("No method #{m}")
  end

  def log
    @log ||= Logger.new(STDOUT)
  end

  def on_rpl_welcome(m)
    @meta_channel = '#gettherebot'
    join_channel meta_channel

    unless ENV["REDIS_URL"].nil?
      @redis_client = Redis.new(:url => ENV["REDIS_URL"])
    else
      @redis_client = Redis.new
    end
    @channels = @redis_client.smembers('channels')
  end

  def on_privmsg(m)
    return unless m[1][0] == '!'
    begin
      command = CommandParser.parse(m[1])
      command.channel = m[0]
      command.user = user_from_message m
      if command.action == :calculate_outs
        result = OutCalculator.evaluate(command)
        out_message = PercentagePresenter.present(result)
        post PRIVMSG, command.channel, out_message
      elsif command.action == :join and command.channel == meta_channel
        if @channels.include? command.user
          post PRIVMSG, meta_channel, "already joined channel '#{command.user}'"
        else
          add_to_channels command.user
          post PRIVMSG, meta_channel, "joined channel '#{command.user}'"
        end
      end
    rescue InvalidCommandException
      post PRIVMSG, command.channel, "invalid command '#{m[1]}'"
    rescue => e
      log.fatal("Caught unknown exception")
      log.fatal(e)
    end
  end
  
  def add_to_channels(channel)
    @channels << channel
    @redis_client.sadd 'channels', channel
    join_channel channel
  end

  def join_channel(channel)
    channel = "##{channel}" unless channel.start_with? '#'
    post JOIN, channel
  end

  def user_from_message(message)
    message.prefix.split('!')[1].split('@')[0]
  end
end

