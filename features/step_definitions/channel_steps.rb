Given(/^the bot is listening for metacommands on "(.*?)"$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

Then(/^the bot joins the channel "(.*?)"$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

Given(/^the bot has joined the channel "(.*?)"$/) do |channel|
  @client.join_channel channel
end

