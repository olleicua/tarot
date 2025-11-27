module StudentPainter
  def student(context:, book_color:)
    left_eye(context:)
    right_eye(context:)
    #mouth(context:)
    book(context:, book_color:)
  end

  def left_eye(context:)
    width = CANVAS_WIDTH / 9
    x_offset = CANVAS_MARGIN + 3 * width
    y_offset = CANVAS_MARGIN + 1.5 * width

    lash_tip,
    lash_curl,
    top_left_curve,
    top,
    top_right_curve,
    right_upper_curve,
    right,
    bottom_right_curve,
    bottom_left_curve,
    left,
    iris_right,
    iris_bottom,
    iris_left,
    iris_l_curve_up,
    iris_t_curve_l,
    iris_top,
    iris_curve_r = [
      [0, width / 4],
      [width / 6, width / 4],
      [width / 4, 0],
      [width / 2, 0],
      [3 * width / 4, 0],
      [width, width / 8],
      [width, 3 * width / 8],
      [2 * width / 3, width / 2],
      [5 * width / 12, width / 2],
      [width / 4, width / 4],
      [7 * width / 8, 5 * width / 12],
      [width / 2, width / 2],
      [width / 2, 5 * width / 12],
      [7 * width / 16, 5 * width / 16],
      [width / 2, width / 4],
      [3 * width / 4, width / 4],
      [7 * width / 8, width / 4]
    ].map{ |x, y| [x_offset + x, y_offset + y].join(',') }

    path =
      "M#{lash_tip}
      C#{lash_curl} #{top_left_curve} #{top}
      C#{top_right_curve} #{right_upper_curve} #{right}
      C#{bottom_right_curve} #{bottom_left_curve} #{left}"

    context.stroke(STUDENT_COLOR)
    context.fill('none')
    context.stroke_width(2)
    context.stroke_linecap('round')
    context.path(path)

    context.define_clip_path('left_eye_clip') do
      context.path(path)
    end

    context.push
    context.clip_path('left_eye_clip')
    context.stroke('none')
    context.fill(STUDENT_COLOR)
    context.circle(
      x_offset + 5 * width / 8, y_offset + 3 * width / 8,
      x_offset + 5 * width / 8, y_offset + width / 6
    )
    context.pop
  end

  def right_eye(context:)
    width = CANVAS_WIDTH / 9
    x_offset = CANVAS_MARGIN + 5.5 * width
    y_offset = CANVAS_MARGIN + 1.15 * width

    left,
    left_curve_up,
    right_curve_up,
    right,
    right_curve_down,
    left_curve_down = [
      [width / 16, 3 * width / 8],
      [0, width / 8],
      [7 * width / 8, -width / 8],
      [width, width / 4],
      [width / 2, 3 * width / 4],
      [width / 4, 3 * width / 8]
    ].map{ |x, y| [x_offset + x, y_offset + y].join(',') }

    path =
      "M#{left}
      C#{left_curve_up} #{right_curve_up} #{right}
      C#{right_curve_down} #{left_curve_down} #{left}"

    context.stroke(STUDENT_COLOR)
    context.fill('none')
    context.stroke_width(2)
    context.stroke_linecap('round')
    context.path(path)

    context.define_clip_path('right_eye_clip') do
      context.path(path)
    end

    context.push
    context.clip_path('right_eye_clip')
    context.stroke('none')
    context.fill(STUDENT_COLOR)
    context.circle(
      x_offset + width / 2, y_offset + 3 * width / 8,
      x_offset + width / 2, y_offset + width / 6
    )
    context.pop
  end

  def mouth(context:)
    width = CANVAS_WIDTH / 12
    x_offset = CANVAS_MARGIN + 4.5 * CANVAS_WIDTH / 10
    y_offset = CANVAS_MARGIN + 3.5 * CANVAS_WIDTH / 10

    left,
    left_curve_up,
    right_curve_up,
    right,
    right_curve_down,
    left_curve_down = [
      [0, width / 8],
      [width / 16, -width / 8],
      [1.25 * width, -width / 8],
      [1.5 * width, width / 16],
      [1.4 * width, 0.8 * width],
      [width / 2, 0.8 * width]
    ].map{ |x, y| [x_offset + x, y_offset + y].join(',') }

    path =
      "M#{left}
      C#{left_curve_up} #{right_curve_up} #{right}
      C#{right_curve_down} #{left_curve_down} #{left}"

    context.stroke('none')
    context.fill(STUDENT_COLOR)
    context.stroke_width(2)
    context.stroke_linecap('round')
    context.path(path)
  end

  def book(context:, book_color:)
    width = CANVAS_WIDTH
    x_offset = CANVAS_MARGIN
    y_offset = CANVAS_MARGIN + (CANVAS_WIDTH + CANVAS_HEIGHT) / 2 - 10

    context.stroke(book_color)
    context.fill('none')
    context.stroke_width(22)
    context.stroke_linecap('round')
    context.line(
      x_offset + width / 8, y_offset - 10,
      x_offset + 7 * width / 8, y_offset - 10
    )

    n = 16

    [
      [
        1,
        [
          [width / 2 + 1 - n, -18],
          [23 * width / 56 + 1 - n, -5 * width / 56 - 18],
          [width / 4, -3 * width / 56],
          [width / 8, -22]
        ]
      ],
      [
        -1,
        [
          [width / 2 + n - 1, -18],
          [33 * width / 56 + n - 1, -5 * width / 56 - 18],
          [3 * width / 4, -3 * width / 56],
          [7 * width / 8, -22]
        ]
      ]
    ].each do |dx, start_positions|
      center,
      center_curve_up,
      edge_curve_up,
      edge = start_positions.map{ |x, y| [x_offset + x, y_offset + y] }

      n.times do
        path =
          "M#{center.join(',')}
          C#{center_curve_up.join(',')}
          #{edge_curve_up.join(',')}
          #{edge.join(',')}"

        context.stroke(STUDENT_COLOR)
        context.fill('none')
        context.stroke_width(2)
        context.stroke_linecap('square')
        context.path(path)

        center[0] += dx
        center_curve_up[0] += dx * [1, 2].sample
        center_curve_up[1] -= [1, 2, 3, 7].sample
        edge_curve_up[0] += dx
        edge_curve_up[1] -= 1
        edge[0] += dx * rand(2)
        edge[1] -= 1
      end
    end
  end
end
