require_relative './card.rb'
require_relative './config.rb'

class Deck
  attr_accessor :table

  def initialize(
    suits: %w[ Gifts Hugs Cuts Sparks ],
    faces: %w[ Student Practitioner Singer Speaker ],
    major_arcana: %w[
      Child
      Magic
      Intuition
      Fertility
      Authority
      Tradition
      Intimacy
      Vehicle
      Power
      Isolation
      Probability
      Integrity
      Reverse
      Closure
      Balance
      Nuance
      Chaos
      Destiny
      Night
      Day
      Discernment
      Integration
    ]
  )
    @config = Config.new(suits:, faces:, major_arcana:)
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
