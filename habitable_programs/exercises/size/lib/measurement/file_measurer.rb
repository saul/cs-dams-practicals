require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/file_locator"

class ClassCounter < Parser::AST::Processor
  attr_reader :total

  def initialize
    @total = 0
  end

  def on_class(node)
    super(node)
    @total += 1
  end
end

class ModuleCounter < Parser::AST::Processor
  attr_reader :total

  def initialize
    @total = 0
  end

  def on_module(node)
    super(node)
    @total += 1
  end
end

module Measurement
  class FileMeasurer < Measurer
    def locator
      Locator::FileLocator.new
    end

    def measurements_for(file)
      {
        lines_of_code: count_lines_of_code(file),
        number_of_modules: count_modules(file),
        number_of_classes: count_classes(file)
      }
    end

    def count_lines_of_code(file)
      file.ast.loc.expression.end.line
    end

    def count_modules(file)
      counter = ModuleCounter.new
      counter.process file.ast
      counter.total
    end

    def count_classes(file)
      counter = ClassCounter.new
      counter.process file.ast
      counter.total
    end
  end
end
