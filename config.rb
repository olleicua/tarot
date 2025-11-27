require_relative './painter.rb'

class Config < Hash
  def initialize(suits:, faces:, major_arcana:, algorithm: :default)
    self[:suits] = suits
    self[:faces] = faces
    self[:major_arcana] = major_arcana
    self[:algorithm] = algorithm
  end

  def paint(**args)
    unless self[:algorithm] == :default
      raise 'paint algorithm not implemented'
    end

    Painter.paint(**args)
  end
end
