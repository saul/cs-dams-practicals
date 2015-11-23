require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"

module Measurement
  class MPCMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      messages = messages_for(method)

      total = messages.total
      to_self = messages.counts[:to_self]
      to_ancestors = messages.counts[:to_ancestors]
      mpc = total - (to_self + to_ancestors)

      {
        total_messages_passed: total,
        messages_passed_to_self: to_self,
        messages_passed_to_ancestors: to_ancestors,
        mpc: mpc
      }
    end

    def messages_for(method)
      finder = MessageFinder.new
      finder.process(method.ast)
      finder
    end
  end

  class MessageFinder < Parser::AST::Processor
    attr_reader :counts

    def initialize
      @counts = {
          other: 0,
          to_self: 0,
          to_ancestors: 0
      }
    end

    def on_send(ast)
      super

      obj = ast.children[0]

      if obj.nil?
        @counts[:to_self] += 1
      elsif obj.type == :zsuper
        @counts[:to_ancestors] += 1
      else
        @counts[:other] += 1
      end
    end

    def total
      @counts[:other] + @counts[:to_self] + @counts[:to_ancestors]
    end
  end
end
