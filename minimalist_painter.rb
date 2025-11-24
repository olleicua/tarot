require "rmagick"

TAU = 2 * Math::PI

CANVAS_HEIGHT = 560
CANVAS_WIDTH = 400
CANVAS_MARGIN = 15

class MinimalistPainter
  def self.paint(rank:, suit:, filename:)
    return if suit == :major
    return unless rank == 0

    canvas = Magick::Image.new(
      CANVAS_WIDTH + (2 * CANVAS_MARGIN),
      CANVAS_HEIGHT + (2 * CANVAS_MARGIN)
    )
    context = Magick::Draw.new

    # background color
    context.fill('#000000')
    context.rectangle(0, 0, canvas.columns, canvas.rows)

    send(
      %i[ gift hug cut spark ][suit],
      context:,
      x: CANVAS_MARGIN,
      y: ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN,
      size: CANVAS_WIDTH
    )

    context.draw(canvas)
    canvas.write(filename)
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

  def self.hug(context:, x:, y:, size:)
    context.stroke('#bb3399')
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

  def self.cut(context:, x:, y:, size:)
    center_x = x + size / 2
    center_y = y + size / 2
    cut_start_angle = rand * TAU
    cut_angle_a = cut_start_angle + 4 * TAU / 11 + rand * 3 * TAU / 11
    cut_angle_b = cut_start_angle + 4 * TAU / 11 + rand * 3 * TAU / 11

    context.fill('#5599ff')
    context.circle(center_x, center_y, x + size / 2, y + size / 7)

    context.fill('#000000')
    context.polygon(
      *from_polar(center_x, center_y, cut_start_angle, size / 2),
      *from_polar(center_x, center_y, cut_angle_a, size / 2),
      *from_polar(center_x, center_y, cut_angle_b, size / 2)
    )
  end

  def self.spark(context:, x:, y:, size:)
    context.stroke('#ff2200')
    context.stroke_width(1)
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
