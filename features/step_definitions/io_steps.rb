require 'client'

class TestClient < Client
  attr_reader :sent

  def initialize
    @sent = {}
  end

  def post(type, channel, text)
    @sent[channel] ||= []
    if type == PRIVMSG
      @sent[channel] << text
    end
  end
end

When(/^I type "(.*?)"$/) do |command|
  @client = TestClient.new
  @channel = 'nothing'
  @client.on_privmsg([@channel, command])
end

Then(/^I should see "(.*?)"$/) do |result|
  @client.sent[@channel].should include(result)
end

Then(/^I should see nil$/) do
  @client.sent[@channel].should be_nil
end