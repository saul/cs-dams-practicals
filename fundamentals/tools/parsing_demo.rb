def print_node(ast, indent=0)
  if ast.respond_to?(:children)
    puts "#{' ' * indent}> #{ast.type}"
    ast.children.map { |x| print_node x, indent+1 }
  else
    puts "#{' ' * indent} #{ast}"
  end
end

require "parser/current"

parser = Parser::CurrentRuby
ast = parser.parse("if @a then @b else @c end")

# Q3
print_node(ast)

# Q4
class SendCounter < Parser::AST::Processor
  attr_reader :total

  def initialize
    @total = 0
  end

  def on_send(node)
    super(node)
    @total += 1
  end
end

parser = Parser::CurrentRuby
ast = parser.parse('1 + 2 + 3')
counter = SendCounter.new
counter.process ast
puts counter.total