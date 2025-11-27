require 'rmagick'
require 'require_all'

require_all './painters'

TAU = 2 * Math::PI

CANVAS_HEIGHT = 560
CANVAS_WIDTH = 400
CANVAS_MARGIN = 15

GIFT_COLOR = 'rgb(39, 168, 0)'
HUG_COLOR = '#bb3399'
CUT_COLOR = '#5599ff'
SPARK_COLOR = '#ff2200'

STUDENT_COLOR = '#ddddff'

FONT_SIZE = 35

class Painter
  extend PainterUtilities

  extend TextPainter
  extend GiftPainter
  extend HugPainter
  extend CutPainter
  extend SparkPainter
  extend StudentPainter

  def self.generate(n)
    card = Deck.new.conjure(n)
    filesystem_name = card.inspect.downcase.tr(' ', '_')
    filename = "images/#{filesystem_name}.png"
    puts "painted #{filename}" if card.paint(filename:)
  end

  def self.paint(rank:, suit:, filename:, text:)
    return if suit == :major

    canvas = Magick::Image.new(
      CANVAS_WIDTH + (2 * CANVAS_MARGIN),
      CANVAS_HEIGHT + (2 * CANVAS_MARGIN)
    )
    context = Magick::Draw.new

    context.fill('#000000')
    context.rectangle(0, 0, canvas.columns, canvas.rows)

    written = send(%i[ gifts hugs cuts sparks ][suit], rank + 1, context:)
    return unless written

    context.draw(canvas)

    add_text(
      canvas:,
      text:,
      color: [GIFT_COLOR, HUG_COLOR, CUT_COLOR, SPARK_COLOR][suit]
    )

    canvas.write(filename)
  end
end
