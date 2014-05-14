require 'out_calculator'

describe OutCalculator do
  describe 'calculating' do
    it 'calculates outs' do
      OutCalculator.calculate(1, 1, 1).should == 1.0
      OutCalculator.calculate(2, 1, 1).should == 0.5
      OutCalculator.calculate(2, 1, 2).should == 1.0
      OutCalculator.calculate(2, 1, 0).should == 0.0
    end

    it 'handles negatives' do
      OutCalculator.calculate(-3, 1, 1).should == 0
      OutCalculator.calculate(3, -1, 1).should == 0
      OutCalculator.calculate(3, 1, -1).should == 0
    end

    it 'handles zeroes' do
      OutCalculator.calculate(0, 1, 1).should == 0
      OutCalculator.calculate(3, 0, 1).should == 0
      OutCalculator.calculate(3, 1, 0).should == 0
    end

    it 'returns 1 if outs or draws is bigger than cards' do
      OutCalculator.calculate(1, 2, 1).should == 1
      OutCalculator.calculate(1, 1, 2).should == 1
    end

    it 'calculates big things' do
      OutCalculator.calculate(13757, 300, 600).should_not be_nan
    end
  end

  describe 'evaluate' do
    let(:options) {
      {
        :cards => 4,
        :outs => 2,
        :draws => 3,
      }
    }
    let(:command) {
      double(:options => options, :arguments => [])
    }

    describe 'prefers options to arguments' do
      it '0 is cards' do
        command.stub(:arguments).and_return([5])
        OutCalculator.should_receive(:calculate).with(4, 2, 3)
        OutCalculator.evaluate(command)
      end
      it '1 is outs' do
        command.stub(:arguments).and_return([nil, 5])
        OutCalculator.should_receive(:calculate).with(4, 2, 3)
        OutCalculator.evaluate(command)
      end
      it '2 is draws' do
        command.stub(:arguments).and_return([nil, nil, 5])
        OutCalculator.should_receive(:calculate).with(4, 2, 3)
        OutCalculator.evaluate(command)
      end
    end

    describe 'defaults to 1 for' do
      it 'cards' do
        options[:cards] = nil
        OutCalculator.should_receive(:calculate).with(1, 2, 3)
        OutCalculator.evaluate(command)
      end
      it 'outs' do
        options[:outs] = nil
        OutCalculator.should_receive(:calculate).with(4, 1, 3)
        OutCalculator.evaluate(command)
      end
      it 'draws' do
        options[:draws] = nil
        OutCalculator.should_receive(:calculate).with(4, 2, 1)
        OutCalculator.evaluate(command)
      end
    end

    context 'valid commands' do
      it 'returns the calculation' do
        OutCalculator.stub(:calculate).with(4, 2, 3).and_return(0.1)
        OutCalculator.evaluate(command).should == 0.1
      end

    end

    context 'invalid commands' do
      describe 'raises exception on strings' do
        it 'cards' do
          options[:cards] = 'something'
          expect {
            OutCalculator.evaluate(command)
          }.to raise_error(InvalidCommandException, "'cards' cannot be a string")
        end
        it 'outs' do
          options[:outs] = 'something'
          expect {
            OutCalculator.evaluate(command)
          }.to raise_error(InvalidCommandException, "'outs' cannot be a string")
        end
        it 'draws' do
          options[:draws] = 'something'
          expect {
            OutCalculator.evaluate(command)
          }.to raise_error(InvalidCommandException, "'draws' cannot be a string")
        end
      end

      it 'raises exception if there are more than 13757 cards' do
        options[:cards] = 13757 + 1
        expect {
          OutCalculator.evaluate(command)
        }.to raise_error(InvalidCommandException, "cannot have more than 13757 cards")
      end

    end
  end
end
