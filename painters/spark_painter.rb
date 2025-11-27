module SparkPainter
  def sparks(n, context:)
    if n == 11
      student(context:, book_color: SPARK_COLOR)
      student_sparks(context:)

      return true
    end

    return if n > 10

    if n == 1
      return spark(
               context:,
               x_offset: CANVAS_MARGIN,
               y_offset: ((CANVAS_HEIGHT - CANVAS_WIDTH) / 2) + CANVAS_MARGIN,
               size: CANVAS_WIDTH,
               fix_height: true
             )
    end

    size = CANVAS_WIDTH / 2
    n_sparks(
      context:,
      n:,
      size:,
      box_params: [
        CANVAS_MARGIN,
        CANVAS_MARGIN + CANVAS_WIDTH - size,
        CANVAS_MARGIN,
        CANVAS_HEIGHT - size - FONT_SIZE
      ]
    )
  end

  def student_sparks(context:)
    size = CANVAS_WIDTH / 3
    n_sparks(
      context:,
      n: (7..11).to_a.sample,
      size:,
      box_params: [
        CANVAS_MARGIN + size / 2,
        CANVAS_MARGIN + CANVAS_WIDTH - 1.5 * size,
        CANVAS_MARGIN + 3 * CANVAS_WIDTH / 10,
        CANVAS_HEIGHT + 15 - 2 * size
      ]
    )
  end

  def n_sparks(context:, n:, size:, box_params:)
    n.times do
      x_offset, y_offset = rand_in_box(*box_params)
      spark(context:, x_offset:, y_offset:, size:)
    end
  end

  def spark(context:, x_offset:, y_offset:, size:, fix_height: false)
    context.stroke(SPARK_COLOR)
    context.stroke_width(2)
    context.fill_opacity(0)
    context.stroke_linecap('butt')

    scale_reduction = 0.4 * rand
    scale = 1 - scale_reduction
    a, b, c, d = [
      [size / 2, size],
      rand_in_box(0, size, size / 2, 3 * size / 4),
      [size / 2, size / 3],
      rand_in_box(size / 4, 3 * size / 4, 0, 0)
    ].map do |x, y|
      [
        x_offset + x,
        y_offset + y * scale + scale_reduction
      ].join(',')
    end

    context.path("M#{a} C#{b} #{c} #{d}")
  end
end
