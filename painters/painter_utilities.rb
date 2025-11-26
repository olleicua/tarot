module PainterUtilities
  def rand_in_box(x1, x2, y1, y2)
    x = x1 + rand(1 + x2 - x1)
    y = y1 + rand(1 + y2 - y1)
    [x, y]
  end

  def string_from_box(*args)
    x, y = rand_in_box(*args)
    "#{x},#{y}"
  end

  def rotate_point(
        angle, x, y,
        cx = CANVAS_MARGIN + CANVAS_WIDTH / 2,
        cy = CANVAS_MARGIN + CANVAS_HEIGHT / 2
      )
    [
      (x - cx) * Math.cos(angle) - (y - cy) * Math.sin(angle) + cx,
      (x - cx) * Math.sin(angle) + (y - cy) * Math.cos(angle) + cy
    ]
  end

  def from_polar(center_x, center_y, theta, r)
    [
      center_x + (Math.cos(theta) * r).round,
      center_y + (Math.sin(theta) * r).round
    ]
  end
end
