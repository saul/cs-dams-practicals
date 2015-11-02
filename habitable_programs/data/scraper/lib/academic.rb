class Academic
  attr_reader :name, :position

  def initialize(name:, position:)
    @name = name
    @position = position
  end

  def wisdom
    if @position == :lecturer
      sample(1, 5)
    elsif @position == :senior
      sample(10, 15)
    else
      sample(20, 30)
    end
  end

  def availability
    if @position == :lecturer
      sample(20, 25)
    elsif @position == :senior
      sample(15, 20)
    else
      sample(1, 10)
    end
  end

  def bribe
    if @position == :lecturer
      %i(chocolate coffee).sample
    elsif @position == :senior
      %i(theatre_tickets cake).sample
    else
      %i(truffles champagne).sample
    end
  end

  private

  def sample(min, max)
    (min..max).to_a.sample
  end
end