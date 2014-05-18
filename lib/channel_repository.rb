class ChannelRepository
  attr_reader :channels
  def self.from_redis(redis_client)
    ChannelRepository.new :channels => redis_client.smembers('channels'), :redis => redis_client
  end

  def initialize(options)
    @channels = options[:channels]
    @redis = options[:redis]
  end

  def method_missing(name, *args, &block)
    begin
      @channels.send(name, *args, &block)
    rescue NoMethodError => e
      raise NoMethodError.new("undefined method '#{name}' for #{self}")
    end
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
