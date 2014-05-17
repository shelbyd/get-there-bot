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
    @channel_repository = ChannelRepository.from_redis @redis_client
    join_all_channels
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
        if @channel_repository.channels.include? command.user
          post PRIVMSG, meta_channel, "already joined channel '#{command.user}'"
        else
          add_to_channels command.user
          post PRIVMSG, meta_channel, "joined channel '#{command.user}'"
        end
      elsif command.action == :leave and command.channel == meta_channel
        if @channel_repository.channels.include? command.user
          @channel_repository.remove(command.user)
          post PART, "##{command.user}"
          post PRIVMSG, meta_channel, "left channel '#{command.user}'"
        else
          post PRIVMSG, meta_channel, "not on channel '#{command.user}'"
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
    @channel_repository.add channel
    join_channel channel
  end

  def join_all_channels
    @channel_repository.channels.each do |channel|
      join_channel channel
    end
  end

  def join_channel(channel)
    channel = "##{channel}" unless channel.start_with? '#'
    post JOIN, channel
  end

  def user_from_message(message)
    message.prefix.split('!')[1].split('@')[0]
  end
end

