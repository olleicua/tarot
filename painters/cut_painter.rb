module CutPainter
  def cuts(n, context:)
    if n == 11
      student(context:, book_color: SPARK_COLOR)
    end

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

  def cut(context:, size:, center_x:, center_y:, start_position:)
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
end
