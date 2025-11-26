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
    return if n > 10

    if n == 1
      return gift(
        context:,
        base_x: CANVAS_MARGIN,
        base_y: ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN,
        size: CANVAS_WIDTH,
        position: :ace
      )
    end

    size = (CANVAS_HEIGHT + CANVAS_WIDTH) / 8
    base_x = CANVAS_MARGIN + (CANVAS_WIDTH - 3 * size) / 2
    base_y = CANVAS_MARGIN
    (0..11).to_a.shuffle[0 .. n - 1].each do |position|
      gift(context:, size:, base_x:, base_y:, position:)
    end
  end

  def self.gift(context:, base_x:, base_y:, size:, position:)
    top, left, center, right, bottom = [
      rand_in_box(68, 127, 128, 155),
      rand_in_box(0, 26, 128, 187),
      rand_in_box(52, 74, 180, 202),
      rand_in_box(101, 127, 197, 255),
      rand_in_box(0, 58, 229, 255)
    ].shuffle

    if position == :ace
      x, y = base_x, base_y
    else
      x = base_x + size * (position % 3)
      y = base_y + size * (position / 3)
    end

    tlo, tro, bro, blo, tli, tri, bri, bli = [
      [x, y],
      [x + size, y],
      [x + size, y + size],
      [x, y + size],
      [x + size / 4, y + size / 4],
      [x + 3 * size / 4, y + size / 4],
      [x + 3 * size / 4, y + 3 * size / 4],
      [x + size / 4, y + 3 * size / 4]
    ]

    unless position == :ace
      if position / 3 == 0
        top = false
        tlo[1] = y + size / 2
        tro[1] = y + size / 2
      end

      if position % 3 == 0
        left = false
        tlo[0] = x + size / 2
        blo[0] = x + size / 2
      end

      if position % 3 == 2
        right = false
        tro[0] = x + size / 2
        bro[0] = x + size / 2
      end

      if position / 3 == 3
        bottom = false
        blo[1] = y + size / 2
        bro[1] = y + size / 2
      end
    end

    if top
      b, g = top
      context.fill("rgb(110, #{g * 1.2}, #{b * 1.2})")
      context.polygon(*tlo, *tro, *tri, *tli)
    end

    if left
      b, g = left
      context.fill("rgb(80, #{g * 1.1}, #{b * 1.1})")
      context.polygon(*tlo, *tli, *bli, *blo)
    end

    if right
      b, g = right
      context.fill("rgb(0, #{g * 0.75}, #{b * 0.75})")
      context.polygon(*tro, *bro, *bri, *tri)
    end

    if bottom
      b, g = bottom
      context.fill("rgb(0, #{g * 0.5}, #{b * 0.5})")
      context.polygon(*blo, *bli, *bri, *bro)
    end

    b, g = center
    context.fill("rgb(50, #{g}, #{b})")
    context.polygon(*tli, *tri, *bri, *bli)
  end

  def self.rotate_point(
        angle, x, y,
        cx = CANVAS_MARGIN + CANVAS_WIDTH / 2,
        cy = CANVAS_MARGIN + CANVAS_HEIGHT / 2
      )
    [
      (x - cx) * Math.cos(angle) - (y - cy) * Math.sin(angle) + cx,
      (x - cx) * Math.sin(angle) + (y - cy) * Math.cos(angle) + cy
    ]
  end

  def self.hugs(n, context:)
    return if n > 10

    if n == 1
      return hug(
               context:,
               **hug_params(
                 x: CANVAS_MARGIN,
                 y: ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN,
                 size: CANVAS_WIDTH,
                 rotate: 0
               )
             )
    end

    sweep_size = TAU / n
    n.times do |i|
      hug(
        context:,
        **hug_params(
          x: CANVAS_MARGIN + CANVAS_WIDTH / 4,
          y: CANVAS_MARGIN + CANVAS_HEIGHT / 2,
          size: CANVAS_WIDTH / 2,
          rotate: sweep_size * i + sweep_size * rand
        )
      )
    end
  end

  def self.hug_params(x:, y:, size:, rotate:)
    wiggle = size / 3
    {
      left_hand: rand_in_box(x + size / 4, x + size / 3, y, y + wiggle),
      left_elbow: rand_in_box(x, x + wiggle, y + size / 3, y + size / 2),
      left_shoulder: rand_in_box(x, x + wiggle, y + size, y + size),
      spine: [x + size / 2, y + size],
      right_shoulder:
        rand_in_box(x + size - wiggle, x + size, y + size, y + size),
      right_elbow:
        rand_in_box(x + size - wiggle, x + size, y + size / 3, y + size / 2),
      right_hand:
        rand_in_box(x + 2 * size / 3, x + 3 * size / 4, y, y + wiggle)
    }.map do |key, value|
      [
        key,
        rotate_point(rotate, *value).join(',')
      ]
    end.to_h
  end

  def self.hug(
        context:,
        left_hand:,
        left_elbow:,
        left_shoulder:,
        spine:,
        right_shoulder:,
        right_elbow:,
        right_hand:
      )
    path =
      "M#{left_hand}
       C#{left_elbow}
       #{left_shoulder}
       #{spine}
       C#{right_shoulder}
       #{right_elbow}
       #{right_hand}"

    context.stroke(HUG_COLOR)
    context.stroke_width(12)
    context.fill_opacity(0)
    context.stroke_linecap('round')
    context.path(path)
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
