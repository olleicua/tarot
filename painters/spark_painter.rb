module SparkPainter
  def sparks(n, context:)
    return student(context:) if n == 11

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

  def spark(context:, x:, y:, size:)
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
