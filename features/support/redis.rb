After do
  client = Redis.new
  client.smembers('channels').each do |channel|
    client.srem('channels', channel)
  end
end
