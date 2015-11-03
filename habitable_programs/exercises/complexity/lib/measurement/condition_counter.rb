require_relative "counter"

module Measurement
  class ConditionCounter < Counter
    def on_send(node)
      super node

      # count calls to conditional operator methods
      increment if [:==, :!=, :<=, :>=, :<, :>].include? node.children[1]
    end

    def on_if(node)
      super node

      # only count if expressions if both branches are not nil
      increment unless node.children[1].nil? or node.children[2].nil?
    end

    def on_and(node)
      super node
      increment
    end

    def on_or(node)
      super node
      increment
    end

    def on_case(node)
      super node
      increment unless node.children.last.nil?
    end

    def on_when(node)
      super node
      increment
    end

    def on_rescue(node)
      super node
      increment
    end
  end
end
