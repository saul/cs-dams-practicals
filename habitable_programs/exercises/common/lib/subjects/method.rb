require_relative "subject"
require "unparser"

module Subjects
  class Method < Subject
    attr_reader :source_file, :ast

    def initialize(source_file, ast)
      @source_file = source_file
      @ast = ast
    end

    def to_s
      "#{file_name}##{method_name}"
    end

    def file_name
      source_file.to_s
    end

    def method_name
      name_node = ast.children.first

      if name_node.is_a? Symbol
        name_node
      else
        Unparser.unparse name_node
      end
    end
  end
end
