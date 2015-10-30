require 'delegate'

module Defer
  class Block < SimpleDelegator
    def self.run(base, &block)
      self.new(base).run(&block)
    end

    def run(&block)
      ret = self.instance_eval(&block)
      _cleanup
      ret
    end

    def defer(&block)
      _stack.unshift(block)
    end

    private

    def _stack
      @_stack ||= []
    end

    def _cleanup
      _stack.each do |blk|
        blk.call
      end
    end
  end
end
