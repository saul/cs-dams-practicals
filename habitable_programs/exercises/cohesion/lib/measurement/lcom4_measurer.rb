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

    def on_send(ast)
      return unless ast.children[0].nil?
      return unless ast.children[1] == :sym

      # extract the method name
      access_type = ast.children[1] == :attr_reader

      reader_dependent = ast.children[1].children[0]
      writer_dependent = "#{reader_dependent}=".to_sym
      dependee = "@#{reader_dependent}".to_sym

      dependencies.add(reader_dependent, dependee) if [:attr_reader, :attr_accessor].include? access_type
      dependencies.add(writer_dependent, dependee) if [:attr_writer, :attr_accessor].include? access_type
    end

    def on_def(ast)
      method = ast.children[0]
      return if method == :initialize

      method_processor = MethodProcessor.new
      method_processor.process(ast)

      dependencies.add_all(method, method_processor.messages)

      super
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
        messages << obj.children[0]
      else
        super
      end
    end

    def messages
      @messages ||= []
    end
  end
end
