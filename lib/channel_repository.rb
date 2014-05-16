class ChannelRepository
  attr_reader :channels
  def self.from_redis(redis_client)
    ChannelRepository.new :channels => redis_client.smembers('channels'), :redis => redis_client
  end

  def initialize(options)
    @channels = options[:channels]
    @redis = options[:redis]
  end

  def add(channel)
    @channels << channel
    @redis.sadd('channels', channel)
  end

  def remove(channel)
    @channels.delete channel
    @redis.srem('channels', channel)
  end
end
