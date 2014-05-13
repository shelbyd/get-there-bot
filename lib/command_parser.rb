class CommandParser

  def self.is_command?(string)
    string.strip.start_with? '!'
  end

  def self.parse(string, options = {})
    command_split = string.split(' ', 2)
    action = command_split[0][1..-1].gsub('-', '_').to_sym
    raise CommandParsingException if action.size == 0

    @arguments = []
    @options = options

    @arguments_string = command_split[1]
    if !@arguments_string.nil? and @arguments_string.size
      parse_for_arguments
      parse_for_options
    end

    Command.new(action, @arguments, @options)
  end

  private

    def self.parse_for_arguments
      @in_option = false
      @in_text = false

      @arguments_string.split(' ').each do |argument|
        @argument = argument
        if start_of_text?
          go_into_text
        elsif @in_text
          @in_text = false if end_of_text?
        elsif valid_option?
          @in_option = true
        elsif @in_option
          @in_option = false
        else
          @arguments << @argument
        end
      end
    end

    def self.go_into_text
      @in_option = false
      @in_text = true
    end

    def self.parse_for_options
      @option = nil
      @in_text = false
      @text = nil

      @arguments_string.split(' ').each do |argument|
        @argument = argument
        start_or_build_option
      end
    end

    def self.start_or_build_option
      if valid_option?
        @option = option_as_symbol
        @options[@option] = true
      else
        build_option
      end
    end

    def self.build_option
      if start_of_text?
        build_start_of_text
      elsif @in_text
        build_text
      else
        @options[@option] = parsed_option
        @option = nil
      end
    end

    def self.build_start_of_text
      @in_text = true
      @text = @argument[1..-1]
    end

    def self.build_text
      @text += ' '
      if end_of_text?
        add_text_for_option
      else
        @text += @argument
      end
    end

    def self.add_text_for_option
      @in_text = false
      @options[@option] = @text + @argument[0..-2]
      @option = nil
    end

    def self.option_as_symbol
      @argument[2..-1].gsub('-', '_').to_sym
    end

    def self.valid_option?
      @argument.start_with? '--' and @argument.size >= 3
    end

    def self.start_of_text?
      @argument[0] == '"'
    end

    def self.end_of_text?
      @argument[-1] == '"'
    end

    def self.parsed_option
      begin
        Integer(@argument)
      rescue ArgumentError, TypeError
        begin
          Float(@argument)
        rescue ArgumentError, TypeError
          @argument
        end
      end
    end
end

class CommandParsingException < Exception; end

class Command < Struct.new(:action, :arguments, :options); end
