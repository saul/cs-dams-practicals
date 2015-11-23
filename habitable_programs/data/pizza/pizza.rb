class Pizza
  def bake
    @toppings.get_all
    @oven.cook
  end

  def rating
    @toppings.average_rating
  end
end