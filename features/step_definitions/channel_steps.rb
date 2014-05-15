Given(/^the bot is listening for metacommands on "(.*?)"$/) do |channel|
  @client.meta_channel = channel
end

Then(/^the bot joins the channel "(.*?)"$/) do |channel|
  @client.channels.should include channel
end

Given(/^the bot has joined the channel "(.*?)"$/) do |channel|
  @client.join_channel channel
end

