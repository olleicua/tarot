require_relative './card.rb'
require_relative './config.rb'

class Deck
  attr_accessor :table

  def initialize(**kwargs)
    @config = Config.new(**kwargs)
    collect
    shuffle
  end

  def draw(n = 1)
    n.times {
      card = @cards.pop
      @table << card
    }

    n == 1 ? @table.last : @table
  end

  def conjure(n)
    Card.new(n, config: @config)
  end

  def shuffle
    @cards.shuffle!
    nil
  end

  def cut
    cut_size = rand(@cards.size)
    @cards = @cards[cut_size..] + @cards[...cut_size]
    nil
  end

  def collect
    @cards = (0..77).map { |n| conjure(n) }
    @table = []
  end
end
