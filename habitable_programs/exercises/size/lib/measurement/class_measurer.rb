require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/class_locator"

class MethodCounter < Parser::AST::Processor
  attr_reader :total

  def initialize
    @total = 0
  end

  def on_def(node)
    super(node)
    @total += 1
  end
end

class ClassMethodCounter < Parser::AST::Processor
  attr_reader :total

  def initialize
    @total = 0
  end

  def on_defs(node)
    super(node)
    @total += 1
  end
end

class AttributeCounter < Parser::AST::Processor
  attr_reader :instance_vars

  def initialize
    @instance_vars = Set.new()
  end

  def total
    @instance_vars.count
  end

  def on_send(node)
    super(node)

    case node.children[1]
      when :attr_accessor, :attr_reader, :attr_writer
        @instance_vars.add node.children[2].children.first
    end
  end

  def on_ivasgn(node)
    super(node)
    @instance_vars.add clean_method_name(node.children.first)
  end

  private
  def clean_method_name(name)
    name.to_s.sub(/^@/, '').intern
  end
end

module Measurement
  class ClassMeasurer < Measurer
    def locator
      Locator::ClassLocator.new
    end

    def measurements_for(clazz)
      {
        lines_of_code: count_lines_of_code(clazz),
        number_of_methods: count_methods(clazz),
        number_of_class_methods: count_class_methods(clazz),
        number_of_attribtutes: count_attributes(clazz)
      }
    end

    def count_lines_of_code(clazz)
      loc = clazz.ast.loc

      # subtract end line by start line
      loc.expression.end.line - loc.line + 1
    end

    def count_methods(clazz)
      counter = MethodCounter.new
      counter.process clazz.ast
      counter.total
    end

    def count_class_methods(clazz)
      counter = ClassMethodCounter.new
      counter.process clazz.ast
      counter.total
    end

    def count_attributes(clazz)
      counter = AttributeCounter.new
      counter.process clazz.ast
      counter.total
    end
  end
end
