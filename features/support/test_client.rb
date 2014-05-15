require 'client'
require 'fakeredis'

class TestClient < Client
  attr_reader :sent

  def initialize
    @sent = {}
    @channels = []
  end

  def post(type, channel, text='')
    channel = "##{channel}" unless channel.start_with? '#'
    if type == PRIVMSG
      @sent[channel] << text
    elsif type == JOIN
      @sent[channel] ||= []
    end
  end

  def meta_channel=(channel)
    @sent[channel] ||= []
    @meta_channel = channel
  end
end

Before do
  @client = TestClient.new
  @client.on_rpl_welcome(nil)
end
