require 'net/irc'
require 'out_calculator'

class SimpleClient < Net::IRC::Client
  def on_rpl_welcome(m)
    ENV['CHANNELS'].split(', ').each do |channel|
      post JOIN, "##{channel}"
    end
  end

  def on_privmsg(m)
    return unless m[1][0] == '!'
    channel = m[0]
    message_parts = m[1].split(' ', 2)
    command = message_parts[0][1..-1]
    arguments = message_parts[1]
    if command == 'calculate_outs'
      arguments = arguments.split(' ')
      cards = arguments[0].to_i
      outs = arguments[1].to_i
      draws = arguments[2].to_i
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
