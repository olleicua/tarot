module TextPainter
  def add_text(canvas:, text:, color:)
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
end
