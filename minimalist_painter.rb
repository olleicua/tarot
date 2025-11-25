require "rmagick"

TAU = 2 * Math::PI

CANVAS_HEIGHT = 560
CANVAS_WIDTH = 400
CANVAS_MARGIN = 15

GIFT_COLOR = 'rgb(39, 168, 0)'
HUG_COLOR = '#bb3399'
CUT_COLOR = '#5599ff'
SPARK_COLOR = '#ff2200'

FONT_SIZE = 35

class MinimalistPainter
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

  def self.add_text(canvas:, text:, color:)
    text_context = Magick::Draw.new

    text_context.font_family = 'Arial'
    text_context.pointsize = FONT_SIZE
    text_context.gravity = Magick::CenterGravity

    text_context.annotate(
      canvas, 0, 0,
      0, CANVAS_HEIGHT / 2 - FONT_SIZE,
      text
    ) { |options| options.fill = color }
  end

  def self.rand_in_box(x1, x2, y1, y2)
    x = x1 + rand(1 + x2 - x1)
    y = y1 + rand(1 + y2 - y1)
    [x, y]
  end

  def self.string_from_box(*args)
    x, y = rand_in_box(*args)
    "#{x},#{y}"
  end

  def self.gifts(n, context:)
    return unless n == 1

    gift(
      context:,
      x: CANVAS_MARGIN,
      y: ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN,
      size: CANVAS_WIDTH
    )
  end

  def self.gift(context:, x:, y:, size:)
    top, left, center, right, bottom = [
      rand_in_box(63, 127, 128, 160),
      rand_in_box(0, 31, 128, 192),
      rand_in_box(47, 79, 175, 207),
      rand_in_box(96, 127, 192, 255),
      rand_in_box(0, 63, 224, 255)
    ].shuffle

    r, g = top
    context.fill("rgb(#{r}, #{g}, 0)")
    context.polygon(
      x, y,
      x + size, y,
      x + 3 * size / 4, y + size / 4,
      x + size / 4, y + size / 4
    )

    r, g = left
    context.fill("rgb(#{r}, #{g}, 0)")
    context.polygon(
      x, y,
      x + size / 4, y + size / 4,
      x + size / 4, y + 3 * size / 4,
      x, y + size
    )

    r, g = center
    context.fill("rgb(#{r}, #{g}, 0)")
    context.polygon(
      x + size / 4, y + size / 4,
      x + 3 * size / 4, y + size / 4,
      x + 3 * size / 4, y + 3 * size / 4,
      x + size / 4, y + 3 * size / 4
    )

    r, g = right
    context.fill("rgb(#{r}, #{g}, 0)")
    context.polygon(
      x + size, y,
      x + size, y + size,
      x + 3 * size / 4, y + 3 * size / 4,
      x + 3 * size / 4, y + size / 4
    )

    r, g = bottom
    context.fill("rgb(#{r}, #{g}, 0)")
    context.polygon(
      x, y + size,
      x + size  / 4, y + 3 * size / 4,
      x + 3 * size / 4, y + 3 * size / 4,
      x + size, y + size
    )
  end

  def self.hugs(n, context:)
    return unless n == 1

    hug(
      context:,
      x: CANVAS_MARGIN,
      y: ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN,
      size: CANVAS_WIDTH
    )
  end

  def self.hug(context:, x:, y:, size:)
    context.stroke(HUG_COLOR)
    context.stroke_width(8)
    context.fill_opacity(0)
    context.stroke_linecap('round')

    wiggle = size / 3
    context.path(
      "M#{string_from_box(x + size / 4, x + size / 3, y, y + wiggle)}
      C#{string_from_box(x, x + wiggle, y + size / 3, y + size / 2)}
      #{string_from_box(x, x + wiggle, y + size, y + size)}
      #{x + size / 2},#{y + size}
      C#{string_from_box(x + size - wiggle, x + size, y + size, y + size)}
      #{string_from_box(x + size - wiggle, x + size, y + size / 3, y + size / 2)}
      #{string_from_box(x + 2 * size / 3, x + 3 * size / 4, y, y + wiggle)}"
    )
  end

  def self.from_polar(center_x, center_y, theta, r)
    [
      center_x + (Math.cos(theta) * r).round,
      center_y + (Math.sin(theta) * r).round
    ]
  end

  def self.cuts(n, context:)
    return if n > 10

    x = CANVAS_MARGIN
    y = ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN
    size = CANVAS_WIDTH
    center_x = x + size / 2
    center_y = y + size / 2

    context.fill(CUT_COLOR)
    context.circle(center_x, center_y, x + size / 2, y + size / 7)

    (0..9).to_a.shuffle[0 .. n - 1].each do |start_position|
      cut(context:, size:, center_x:, center_y:, start_position:)
    end
  end

  def self.cut(context:, size:, center_x:, center_y:, start_position:)
    cut_start_angle = start_position * TAU / 10
    wiggle = rand * 2 * TAU / 11
    cut_angle_a = cut_start_angle + 3.75 * TAU / 11 + rand * 1.5 * TAU / 11 + wiggle
    cut_angle_b = cut_start_angle + 3.75 * TAU / 11 + rand * 1.5 * TAU / 11 + wiggle

    context.fill('#000000')
    context.polygon(
      *from_polar(center_x, center_y, cut_start_angle, size / 2),
      *from_polar(center_x, center_y, cut_angle_a, size / 2),
      *from_polar(center_x, center_y, cut_angle_b, size / 2)
    )
  end

  def self.sparks(n, context:)
    return if n > 10

    if n == 1
      return spark(
               context:,
               x: CANVAS_MARGIN,
               y: ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN,
               size: CANVAS_WIDTH
             )
    end

    size = CANVAS_WIDTH / 2
    n.times do
      x, y = rand_in_box(
        CANVAS_MARGIN,
        CANVAS_MARGIN + CANVAS_WIDTH - size,
        CANVAS_MARGIN,
        CANVAS_HEIGHT - size - FONT_SIZE
      )
      spark(context:, x:, y:, size:)
    end
  end

  def self.spark(context:, x:, y:, size:)
    context.stroke(SPARK_COLOR)
    context.stroke_width(2)
    context.fill_opacity(0)
    context.stroke_linecap('butt')

    context.path(
      "M#{x + size / 2},#{y + size}
      C#{string_from_box(x, x + size, y + size / 2, y + 3 * size / 4)}
      #{x + size / 2},#{y + size / 3}
      #{string_from_box(x + size / 4, x + 3 * size / 4, y, y)}"
    )
  end
end
