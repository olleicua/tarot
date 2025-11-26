require_relative './painter.rb'

class Config < Hash
  def initialize(suits:, faces:, major_arcana:, paint_algorithm: :default)
    self[:suits] = suits
    self[:faces] = faces
    self[:major_arcana] = major_arcana
    self[:paint_algorithm] = paint_algorithm
  end

  def paint(**args)
    unless self[:paint_algorithm] == :default
      raise 'paint algorithm not implemented'
    end

    MinimalistPainter.paint(**args)
  end
end
