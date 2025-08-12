class Card
  def initialize(n, config:)
    @n = n
    @config = config
  end

  def inspect
    return @config[:major_arcana][@n - 56] if major?

    "#{rank} of #{suit}"
  end

  def major?
    @n > 55
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
end

