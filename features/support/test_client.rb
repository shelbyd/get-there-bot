require 'client'

class TestClient < Client
  attr_reader :sent

  def initialize
    @sent = {}
    @channels = []
  end

  def post(type, channel, text)
    return unless @channels.include? channel
    @sent[channel] ||= []
    if type == PRIVMSG
      @sent[channel] << text
    end
  end

  def join_channel(channel)
    @channels << channel
  end
end

Before do
  @client = TestClient.new
end
