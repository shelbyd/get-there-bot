require 'client'
require 'fakeredis'

class TestClient < Client
  attr_reader :sent, :repository, :joined_channels

  def initialize
    @sent = {}
    @channels = []
    @joined_channels = []
  end

  def post(type, channel, text='')
    channel = "##{channel}" unless channel.start_with? '#'
    if type == PRIVMSG
      @sent[channel] << text
    elsif type == JOIN
      @sent[channel] ||= []
      @joined_channels << channel[1..-1]
    elsif type == PART
      @joined_channels.delete channel[1..-1]
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
