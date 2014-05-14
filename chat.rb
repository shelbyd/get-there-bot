require './lib/client.rb'

Client.new('irc.twitch.tv', 6667,
                 :pass => ENV['OAUTH_PASS'].dup,
                 :user => ENV['TWITCH_USERNAME'].dup,
                 :nick => ENV['TWITCH_USERNAME'].dup,
                 :real => ENV['TWITCH_USERNAME'].dup,
                ).start
