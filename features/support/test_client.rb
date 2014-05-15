require 'client'
require 'fakeredis'

class TestClient < Client
  attr_reader :sent

  def initialize
    @sent = {}
    @channels = []
  end

  def post(type, channel, text)
    return unless @channels.include?(channel) or @meta_channel == channel
    @sent[channel] ||= []
    if type == PRIVMSG
      @sent[channel] << text
    end
  end

  def join_channel(channel)
    if channel.start_with? '#'
      @channels << channel[1..-1]
      @channels << channel
    else
      @channels << channel
      @channels << '#' + channel
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
