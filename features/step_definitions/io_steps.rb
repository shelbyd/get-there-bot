When(/^I type "(.*?)" in "(.*?)"$/) do |command, channel|
  @channel = channel
  message = Net::IRC::Message.new("#{@nick}!#{@nick}@#{@nick}.tmi.twitch.tv", Net::IRC::Constants::PRIVMSG, [@channel, command])
  @client.on_privmsg(message)
end

Then(/^I should see "(.*?)"$/) do |result|
  @client.sent[@channel].should include(result)
end

Then(/^I should see nothing$/) do
  @client.sent[@channel].should be_nil
end
