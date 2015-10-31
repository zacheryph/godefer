require 'delegate'

module Defer
  class Block < SimpleDelegator
    def self.run(base, &block)
      new(base).run(&block)
    end

    def run(&block)
      ret = instance_eval(&block)
    rescue Exception => e
      @_exception = e
    ensure
      _cleanup
      raise @_exception if @_exception && !@_recovered
      ret
    end

    def defer(&block)
      _stack.unshift(block)
    end

    def recover
      @_recovered = true
      @_exception
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
