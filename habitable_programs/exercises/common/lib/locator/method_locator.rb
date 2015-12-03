require_relative "../subjects/method"

module Locator
  class MethodLocator
    def find_subjects_in(project)
      project.files.flat_map do |source_file|
        processor = FindMethodsWithinClassProcessor.new(source_file)
        processor.process(source_file.ast)
        processor.methods
      end
    end

    class FindMethodsWithinClassProcessor < Parser::AST::Processor
      attr_reader :methods

      def initialize(source_file)
        @source_file = source_file
        @methods = []
      end

      def on_class(node)
        method_processor = FindMethodProcessor.new(@source_file)
        method_processor.process(node)

        @methods += method_processor.methods
      end
    end

    class FindMethodProcessor < Parser::AST::Processor
      attr_reader :methods

      def initialize(source_file)
        @source_file = source_file
        @methods = []
      end

      def process_function_node(node)
        @methods << Subjects::Method.new(@source_file, node)
      end

      alias_method :on_def, :process_function_node

      def on_defs(node)
        # HACK: remap defs -> def with a name of "self.method_name"
        new_node = node.updated :def, ["self.#{node.children[1]}".to_sym, node.children[2], node.children[3]]
        process_function_node new_node
      end

      alias_method :on_block, :process_function_node
    end
  end
end
