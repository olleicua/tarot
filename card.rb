class Card
  def self.generate_image(n)
    card = Deck.new.conjure(n)
    filesystem_name = card.inspect.downcase.tr(' ', '_')
    filename = "images/#{filesystem_name}.png"
    puts "painted #{filename}" if card.paint(filename:)
  end

  def initialize(n, config:)
    @n = n
    @config = config
  end

  def inspect
    to_s
  end

  def to_s
    major_arcana || "#{rank} of #{suit}"
  end

  def major_arcana
    return if @n < 56

    number = @n - 56
    name = @config[:major_arcana][number]
    "#{number}. #{name}".tr('-', ' ')
  end

  def rank
    (
      %w[ Ace Two Three Four Five Six Seven Eight Nine Ten ] +
      @config[:faces]
    )[@n % 14]
  end

  def suit
    @config[:suits][@n / 14]
  end

  def paint(filename:)
    if major_arcana
      return @config.paint(
               rank: @n - 56,
               suit: :major,
               filename:,
               text: inspect
             )
    end

    @config.paint(
      rank: @n % 14,
      suit: @n / 14,
      filename:,
      text: inspect
    )
  end
end
