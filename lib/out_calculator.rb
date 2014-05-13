class OutCalculator

  def self.calculate(cards, outs, draws)
    raise InvalidCommandException if cards.is_a? String or outs.is_a? String or draws.is_a? String
    return 0 if cards <= 0 or outs <= 0 or draws <= 0
    all_draws = choose(cards, draws)
    draws_containing_out = choose(cards - outs, draws)
    1 - (draws_containing_out/all_draws.to_f)
  end

  def self.choose(n, k)
    return 0 if k > n
    return 1 if k == 0 or n == k
    choose(n-1, k-1) + choose(n-1, k)
  end
end

class InvalidCommandException < Exception; end
