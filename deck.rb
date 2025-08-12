require_relative './card.rb'

class Deck
  attr_accessor :table

  def initialize(
    suits: %w[ Gifts Hugs Cuts Sparks ],
    faces: %w[ Student Practitioner Singer Speaker ],
    major_arcana: %w[
      Child
      Mage
      Elevated Woman
      Queen
      King
      Elevated Man
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
    @config = { suits:, faces:, major_arcana: }
    collect
  end

  def draw(n = 1)
    n.times {
      card = @cards.pop
      @table << card
    }

    n == 1 ? @table.last : @table
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
    @cards = (1..78).map { |n| Card.new(n, config: @config) }.shuffle
    @table = []
  end
end
