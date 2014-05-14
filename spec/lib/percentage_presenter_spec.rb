require 'percentage_presenter'

describe PercentagePresenter do
  it 'dispays percentages' do
    percentage = 0.65443
    PercentagePresenter.present(percentage).should == '65.44%'
    percentage = 0.31886
    PercentagePresenter.present(percentage).should == '31.89%'
  end
end