require_relative "counter"

module Measurement
  class BranchCounter < Counter
    def on_send(node)
      super node

      unless node.children.first.nil? or [:==, :!=, :<=, :>=, :<, :>].include? node.children[1]
        increment
      end
    end
  end
end
