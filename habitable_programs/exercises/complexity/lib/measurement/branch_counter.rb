require_relative "counter"

module Measurement
  class BranchCounter < Counter
    def on_send(node)
      super node

      unless [nil, :self].include? node.children.first or [:==, :!=, :<=, :>=, :<, :>].include? node.children[1]
        increment
      end
    end
  end
end
