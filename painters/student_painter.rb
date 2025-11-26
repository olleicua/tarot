module StudentPainter
  def student(context:)
    left_eye(context:)
    right_eye(context:)
    mouth(context:)

    true
  end

  def left_eye(context:)
    width = CANVAS_WIDTH / 10
    x_offset = CANVAS_MARGIN + 3 * width
    y_offset = CANVAS_MARGIN + width

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
    width = CANVAS_WIDTH / 10
    x_offset = CANVAS_MARGIN + 5.5 * width
    y_offset = CANVAS_MARGIN + 0.65 * width

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
    y_offset = CANVAS_MARGIN + 3 * CANVAS_WIDTH / 10

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
end
