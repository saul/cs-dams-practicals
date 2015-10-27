require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"

module Measurement
  class MethodMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      {
        lines_of_code: count_lines_of_code(method),
        number_of_parameters: count_parameters(method)
      }
    end

    def count_lines_of_code(method)
      loc = method.ast.loc

      # subtract end line by start line
      loc.expression.end.line - loc.line + 1
    end

    def count_parameters(method)
      method.ast.children[1].children.count
    end
  end
end
