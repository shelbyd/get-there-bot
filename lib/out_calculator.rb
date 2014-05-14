class OutCalculator

  @memoized = {}

  def self.calculate(cards, outs, draws)
    raise InvalidCommandException if cards.is_a? String or outs.is_a? String or draws.is_a? String
    raise InvalidCommandException if cards >= 4096
    return 0 if cards <= 0 or outs <= 0 or draws <= 0
    return 1 if outs >= cards or draws >= cards
    all_draws = choose(cards, draws)
    draws_containing_out = choose(cards - outs, draws)
    1 - (draws_containing_out/all_draws.to_f)
  end

  def self.choose(n, k)
    return 0 if k > n
    return 1 if k == 0 or n == k
    index = "#{n},#{k}".to_sym
    unless @memoized[index]
      @memoized[index] = choose(n-1, k-1) + choose(n-1, k)
    end
    @memoized[index]
  end
end

class InvalidCommandException < Exception; end
