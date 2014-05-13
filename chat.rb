require 'net/irc'
require 'out_calculator'
require 'command_parser'

class SimpleClient < Net::IRC::Client
  def on_rpl_welcome(m)
    ENV['CHANNELS'].split(', ').each do |channel|
      post JOIN, "##{channel}"
    end
  end

  def on_privmsg(m)
    return unless m[1][0] == '!'
    channel = m[0]
    command = CommandParser.parse(m[1])
    if command.action == :calculate_outs
      cards = command.arguments[0]
      outs = command.arguments[1]
      draws = command.arguments[2]
      result = OutCalculator.calculate(cards, outs, draws)
      post PRIVMSG, channel, (result.to_f * 100).to_s
    end
  end
end

SimpleClient.new('irc.twitch.tv', 6667,
                 :pass => ENV['OAUTH_PASS'].dup,
                 :user => ENV['TWITCH_USERNAME'].dup,
                 :nick => ENV['TWITCH_USERNAME'].dup,
                 :real => ENV['TWITCH_USERNAME'].dup,
                ).start
