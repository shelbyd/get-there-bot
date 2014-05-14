require 'out_calculator'

describe OutCalculator do
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

  it 'errors on strings' do
    expect {
      OutCalculator.calculate('string', 1, 1)
      }.to raise_error(InvalidCommandException)
    expect {
      OutCalculator.calculate(3, 'string', 1)
      }.to raise_error(InvalidCommandException)
    expect {
      OutCalculator.calculate(3, 1, 'string')
      }.to raise_error(InvalidCommandException)
  end

  it 'is invalid if there are more than 4096 cards' do
    expect {
      OutCalculator.calculate(4096, 1, 1)
    }.to raise_error(InvalidCommandException)
    expect {
      OutCalculator.calculate(4095, 1, 1)
    }.to_not raise_error
  end
end
