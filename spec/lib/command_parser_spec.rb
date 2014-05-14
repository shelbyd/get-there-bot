require 'command_parser'

describe CommandParser do
  it 'knows if something is a command' do
    CommandParser.is_command?('!something').should be_true
    CommandParser.is_command?('  !something').should be_true
    CommandParser.is_command?('something').should be_false
  end

  it 'parses a command' do
    CommandParser.parse('!something').action.should == :something
    CommandParser.parse('!something-else').action.should == :something_else
    expect {
      CommandParser.parse('!')
    }.to raise_error(CommandParsingException)
  end

  it 'parses arguments' do
    CommandParser.parse('!something').arguments.should == []
    CommandParser.parse('!something arg1').arguments.should == ['arg1']
    CommandParser.parse('!something arg1 arg2 arg3').arguments.should == ['arg1', 'arg2', 'arg3']
  end

  it 'parses arguments as types' do
    CommandParser.parse('!something text').arguments[0].should == 'text'
    CommandParser.parse('!something 15').arguments[0].should == 15
    CommandParser.parse('!something 15.6667').arguments[0].should == 15.6667
    CommandParser.parse('!something "some text"').arguments[0].should == 'some text'
  end

  # TODO: Parse a list
  it 'parses options' do
    CommandParser.parse('!something --bool text').options[:bool].should == 'text'
    CommandParser.parse('!something --bool').options[:bool].should be_true
    CommandParser.parse('!something --number 15').options[:number].should == 15
    CommandParser.parse('!something --number 15.6667').options[:number].should == 15.6667
    CommandParser.parse('!something --text "some text"').options[:text].should == 'some text'
  end

  it 'parses complicated commands' do
    parsed = CommandParser.parse('!calculate-outs --bool --text text arg1 --num 15 --float 1.667 --long-text "some long text" arg2')
    parsed.action.should == :calculate_outs
    parsed.arguments.should == ['arg1', 'arg2']
    parsed.options[:bool].should == true
    parsed.options[:text].should == 'text'
    parsed.options[:long_text].should == 'some long text'
    parsed.options[:num].should == 15
    parsed.options[:float].should == 1.667
  end

  it 'allows default options' do
    parsed = CommandParser.parse('!something', :opt => true)
    parsed.options[:opt].should == true
  end
end
