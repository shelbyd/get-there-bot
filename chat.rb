require 'net/irc'

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
      cards_left = arguments[0].to_i
      outs_left = arguments[1].to_i
      cards_to_draw = arguments[2].to_i
      result = 1 - (choose(cards_left - outs_left, cards_to_draw)/choose(cards_left, cards_to_draw).to_f)
      post PRIVMSG, channel, (result.to_f * 100).to_s
    end
  end

  def choose(n, k)
    return 1 if k == 0 or n == k
    choose(n-1, k-1) + choose(n-1, k)
  end
end

SimpleClient.new('irc.twitch.tv', 6667,
                 :pass => ENV['OAUTH_PASS'].dup,
                 :user => ENV['TWITCH_USERNAME'].dup,
                 :nick => ENV['TWITCH_USERNAME'].dup,
                 :real => ENV['TWITCH_USERNAME'].dup,
                ).start
