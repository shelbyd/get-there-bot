require 'channel_repository'

describe ChannelRepository do
  let(:redis) { double(:smembers => ['numotthenummy']).as_null_object }
  let(:repository) { ChannelRepository.from_redis(redis) }
  
  describe '#from_redis' do
    it 'creates a new repository from redis' do
      redis.stub(:smembers).with('channels').and_return(['ch1', 'ch2', 'ch3'])
      ChannelRepository.from_redis(redis).channels.should == ['ch1', 'ch2', 'ch3']
    end
  end

  describe '#add' do
    it 'adds the channel to its list' do
      repository.add('darkest_mage')
      repository.channels.should include('darkest_mage')
    end

    it 'persists the channel' do
      redis.should_receive(:sadd).with('channels', 'darkest_mage').and_return(1)
      repository.add('darkest_mage')
    end
  end

  describe '#remove' do
    it 'removes the channels from its list' do
      repository.remove('numotthenummy')
      repository.channels.should_not include('numotthenummy')
    end

    it 'persists the removing' do
      redis.should_receive(:srem).with('channels', 'numotthenummy').and_return(1)
      repository.remove('numotthenummy')
    end
  end
end
