class Card
  def initialize(n, config:)
    @n = n
    @config = config
  end

  def inspect
    major_arcana || "#{rank} of #{suit}"
  end

  def major_arcana
    return if @n < 56

    @config[:major_arcana][@n - 56].tr('-', ' ')
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
