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
end