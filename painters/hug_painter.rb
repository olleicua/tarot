module HugPainter
  def hugs(n, context:)
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

  def hug_params(x:, y:, size:, rotate:)
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

  def hug(
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

end
