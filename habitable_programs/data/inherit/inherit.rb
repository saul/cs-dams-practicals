class Parent
  def my_first_method
    puts "Die heathen!"
  end
end

class Child < Parent
  def my_first_method
    super.test
    puts "Simple, isn't it?"
  end
end