require 'parser'
require 'unparser'
require 'digest/sha1'
require_relative '../../../common/lib/subjects/project'

module Detection
  class RewrittenNode < Parser::AST::Node
    attr_reader :parent
    attr_reader :original

    def initialize(node, props)
      rewriter = NodeRewriter.new

      on_node_sym = "on_#{node.type.to_s}".to_sym

      children = rewriter.respond_to?(on_node_sym) ? rewriter.send(on_node_sym, node) : node.children

      super(node.type, children.map { |child| RewrittenNode.of_ast_node(child, self) }, props)
    end

    def self.of_ast_node(node, parent=nil)
      if node.respond_to? 'children'
        properties = {original: node}
        properties[:parent] = parent if parent

        RewrittenNode.new(node, properties)
      else
        node
      end
    end

    def assign_properties(props)
      @parent = props[:parent]
      @original = props[:original]
    end
  end

  class NodeRewriter
    def null_single_child(node)
      ['']
    end

    alias_method :on_arg, :null_single_child
    #alias_method :on_str, :null_single_child

    def on_def(node)
      [''] + node.children[1..-1]
    end
  end

  class CloneDetector
    def initialize(root)
      @project = Subjects::Project.new root
    end

    def run
      node_hashes = @project.files.reduce({}) do |node_hashes, file|
        root = RewrittenNode.of_ast_node file.ast
        hash_node node_hashes, root
        node_hashes
      end

      print_clones node_hashes
    end

    private

    def hash_node(node_hashes, node)
      if node.respond_to? 'children'
        node.children.each do |child_node|
          hash_node(node_hashes, child_node)
        end

        if node.children.length > 1 and not [:const, :send, :args].include? node.type
          node_hashes[node.hash] = node_hashes.fetch(node.hash, []) << node
        end
      end

      node.hash
    end

    def ascendants_in_hash(node_hashes, node)
      if node.respond_to? 'parent'
        node_hashes.has_key?(node.parent.hash) or ascendants_in_hash(node_hashes, node.parent)
      else
        false
      end
    end

    def print_clones(node_hashes)
      duplication_candidates = node_hashes.select { |_, clones| clones.length > 1 }

      duplicates = duplication_candidates.reduce({}) do |memo, (hash, clones)|
        topmost_nodes = clones.reject { |clone| ascendants_in_hash duplication_candidates, clone }

        # reject all clones who have an ascendant that is a duplicate
        memo[hash] = topmost_nodes if topmost_nodes.length > 1
        memo
      end

      duplicates.each do |hash, clones|
        first_clone = clones[0]
        puts "\n> Duplicated `#{first_clone.type}` node with #{first_clone.children.length} children (#{hash})"

        clones.each do |cloned_node|
          puts "\n at #{cloned_node.original.location.expression}:"

          # add spaces to indent correctly
          node_text = Unparser.unparse(cloned_node.original).split("\n").join("\n  ")

          puts "  #{node_text}"
        end
      end
    end
  end
end
