require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/module_locator"
require_relative "dependency_graph"

module Measurement
  class LCOM4Measurer < Measurer
    def locator
      Locator::ModuleLocator.new
    end

    def measurements_for(clazz)
      dependencies = process(clazz)

      {
        lcom4: dependencies.number_of_components,
        connected_components: dependencies.components_summary
      }
    end

    def process(clazz)
      processor = ClassProcessor.new(clazz.ast)
      processor.process(clazz.ast)
      processor.dependencies
    end
  end

  class ClassProcessor < Parser::AST::Processor
    def initialize(root)
      @root = root
      @ivars = {}
    end

    # Ignore nested modules
    def on_module(ast)
      super if ast == @root
    end

    # Ignore nested classes
    def on_class(ast)
      super if ast == @root
    end

    def on_def(ast)
      method = ast.children[0]
      return if method == :initialize

      method_processor = MethodProcessor.new
      method_processor.process(ast)

      dependencies.add_all(method, method_processor.messages)

      method_processor.ivars.each do |ivar|
        # add dependencies between methods that use one or more of the same instance variables
        other_methods = ivar_dependencies(ivar)
        other_methods.each { |other| dependencies.add(method, other) }

        other_methods << method
      end

      super
    end

    def ivar_dependencies(ivar)
      @ivars[ivar] ||= []
    end

    def dependencies
      @dependencies ||= DependencyGraph.new
    end
  end

  class MethodProcessor < Parser::AST::Processor
    def on_send(ast)
      obj, message = ast.children

      if obj.nil?
        messages << message
      elsif obj.type == :ivar
        ivars << obj.children[0]
      end
    end

    def messages
      @messages ||= []
    end

    def ivars
      @ivars ||= []
    end
  end
end
