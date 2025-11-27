require_relative './painter.rb'

# A Config is a special type of ruby Hash that has
# four default values which can be overridden.
# For example Config.new(suits: %[ Marbles Pots Nails Boards ])
# would use all of the default values except with new names for the suits.
class Config < Hash
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
        ],
        paint_algorithm: :default
      )
    self[:suits] = suits
    self[:faces] = faces
    self[:major_arcana] = major_arcana
    self[:paint_algorithm] = paint_algorithm
  end

  def paint(**args)
    unless self[:paint_algorithm] == :default
      raise 'paint algorithm not implemented'
    end

    Painter.paint(**args)
  end
end
