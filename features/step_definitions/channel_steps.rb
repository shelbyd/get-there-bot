Given(/^the bot is listening for metacommands on "(.*?)"$/) do |channel|
  @client.meta_channel = channel.start_with?('#') ? channel : "##{channel}"
end

Then(/^the bot joins the channel "(.*?)"$/) do |channel|
  Redis.new.smembers('channels').should include channel
end

Given(/^the bot has joined the channel "(.*?)"$/) do |channel|
  @client.add_to_channels channel
end

Then(/^the bot is not on the channel "(.*?)"$/) do |channel|
  Redis.new.smembers('channels').should_not include(channel)
end

Then(/^the bot has left the channel "(.*?)"$/) do |channel|
  @client.joined_channels.should_not include(channel)
end

