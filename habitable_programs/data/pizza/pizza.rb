class Pizza
  attr_reader :toppings
  attr_writer :oven
  attr_accessor :dumbledore

  def bake
    @toppings.get_all
    @oven.cook
  end

  def rating
    @toppings.average_rating
  end
end