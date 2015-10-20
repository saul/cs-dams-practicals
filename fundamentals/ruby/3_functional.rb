# Q2
def create_taxrate(allowance, basic_rate)
  ->(x) { x < allowance ? 0 : basic_rate }
end

puts "\nQ2:"
puts create_taxrate(10000, 0.2).call(11000)

# Q3
def calculate_tax(gross, &apply)
  gross * apply.call(gross)
end

puts "\nQ3:"
puts calculate_tax(15000) { |gross| gross <= 10000 ? 0 : 0.2 }

# Q4
def sliding_window_min(window_size, list)
  list.each_cons(3).map &:min
end

puts "\nQ4:"
puts sliding_window_min(3, [4, 3, 2, 1, 5, 7, 6, 8, 9])

# Q5
def my_select(xs, &filter)
  [].tap { |out| xs.each { |x| out << x if yield x } }
end

puts "\nQ5:"
puts my_select([1,2,3,4,5]) { |x| x > 3 }

# Q6
def all_substrs(s)
  (1..s.size).inject([]) do |results, len|
    results.concat (0..(s.size-len)).map { |i| s.slice(i, len) }
  end
end

puts all_substrs "Hello"