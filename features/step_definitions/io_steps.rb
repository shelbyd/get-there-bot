When(/^I type "(.*?)" in "(.*?)"$/) do |command, channel|
  @channel = channel
  @client.on_privmsg([@channel, command])
end

Then(/^I should see "(.*?)"$/) do |result|
  @client.sent[@channel].should include(result)
end

Then(/^I should see nothing$/) do
  @client.sent[@channel].should be_nil
end
