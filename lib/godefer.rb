require "defer/version"
require "defer/block"

module Defer
  def self.run(&block)
    Defer::Block.run(nil, &block)
  end

  def with_defer(&block)
    Defer::Block.run(self, &block)
  end
end
