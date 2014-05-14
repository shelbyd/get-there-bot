require 'bigdecimal'

class OutCalculator

  STACK_LIMIT = 13757
  @memoized = {}

  def self.evaluate(command)
    cards = command.arguments[0] || command.options[:cards]
    outs = command.arguments[1] || command.options[:outs]
    draws = command.arguments[2] || command.options[:draws]
    [:cards, :outs, :draws].each { |option|
      if command.options[option].is_a? String
        raise InvalidCommandException.new("'#{option.to_s}' cannot be a string")
      end
    }

    if cards > STACK_LIMIT
      raise InvalidCommandException.new("cannot have more than 13757 cards")
    end

    calculate(cards, outs, draws)
  end

  def self.calculate(cards, outs, draws)
    return 0 if cards <= 0 or outs <= 0 or draws <= 0
    return 1 if outs >= cards or draws >= cards
    all_draws = to_float choose(cards, draws)
    draws_containing_out = to_float choose(cards - outs, draws)
    1 - (draws_containing_out/all_draws)
  end

  def self.choose(n, k)
    return 0 if k > n
    return 1 if k == 0 or n == k
    return choose(n, n-k) if k > n/2
    index = "#{n},#{k}".to_sym
    unless @memoized[index]
      @memoized[index] = (n * choose(n-1, k-1)) / k
    end
    @memoized[index]
  end

  private

    def self.to_float(number)
      if number > Float::MAX
        BigDecimal.new(number)
      else
        number.to_f
      end
    end
end

class InvalidCommandException < Exception; end
