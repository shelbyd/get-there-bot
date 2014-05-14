require 'net/irc'
Dir["./lib/*.rb"].each {|file| require file }

log = Logger.new(STDOUT)

class SimpleClient < Net::IRC::Client
  def on_rpl_welcome(m)
    ENV['CHANNELS'].split(' ').each do |channel|
      post JOIN, "##{channel}"
    end
  end

  def on_privmsg(m)
    return unless m[1][0] == '!'
    begin
      channel = m[0]
      command = CommandParser.parse(m[1], :outs => 1, :draws => 1, :cards => 1)
      if command.action == :calculate_outs
        cards = command.arguments[0] || command.options[:cards]
        outs = command.arguments[1] || command.options[:outs]
        draws = command.arguments[2] || command.options[:draws]
        result = OutCalculator.calculate(cards, outs, draws)
        out_message = PercentagePresenter.present(result)
        post PRIVMSG, channel, out_message
      end
    rescue InvalidCommandException
      post PRIVMSG, channel, "invalid command '#{m[1]}'"
    rescue => e
      log.fatal("Caught unknown exception")
      log.fatal(e)
    end
  end
end

SimpleClient.new('irc.twitch.tv', 6667,
                 :pass => ENV['OAUTH_PASS'].dup,
                 :user => ENV['TWITCH_USERNAME'].dup,
                 :nick => ENV['TWITCH_USERNAME'].dup,
                 :real => ENV['TWITCH_USERNAME'].dup,
                ).start
