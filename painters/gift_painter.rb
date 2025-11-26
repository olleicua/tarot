module GiftPainter
  def gifts(n, context:)
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

  def gift_colors
    [
      rand_in_box(68, 127, 128, 155),
      rand_in_box(0, 26, 128, 187),
      rand_in_box(52, 74, 180, 202),
      rand_in_box(101, 127, 197, 255),
      rand_in_box(0, 58, 229, 255)
    ].shuffle
  end

  def gift_vertices(x:, y:, size:)
    [
      [x, y],
      [x + size, y],
      [x + size, y + size],
      [x, y + size],
      [x + size / 4, y + size / 4],
      [x + 3 * size / 4, y + size / 4],
      [x + 3 * size / 4, y + 3 * size / 4],
      [x + size / 4, y + 3 * size / 4]
    ]
  end

  def gift(context:, base_x:, base_y:, size:, position:)
    top, left, center, right, bottom = gift_colors

    if position == :ace
      x, y = base_x, base_y
    else
      x = base_x + size * (position % 3)
      y = base_y + size * (position / 3)
    end

    tlo, tro, bro, blo, tli, tri, bri, bli = gift_vertices(x:, y:, size:)

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
end
