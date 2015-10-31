require 'test_helper'

class TestMock
  include Defer
  attr_accessor :mock, :inst_var

  def initialize(mock)
    self.inst_var = "inst_var"
    self.mock = mock
  end

  def inst_method
    "inst_method"
  end

  def defers_symbol
    with_defer do
      defer { deferred :defers }
    end
  end

  def defers_var_accessor
    with_defer do
      defer { deferred(inst_var) }
    end
  end

  def defers_method
    with_defer do
      defer { deferred(inst_method) }
    end
  end

  def deferred(*args)
    mock.deferred(*args)
  end
end

describe Defer do
  before do
    @mock = MiniTest::Mock.new
    @defer = TestMock.new(@mock)
  end

  it "defers block calls" do
    @mock.expect :deferred, nil

    @defer.with_defer do
      defer { deferred }
    end

    @mock.verify
  end

  it "reads deferred instance variables" do
    @mock.expect :deferred, nil, ["inst_var"]
    @defer.defers_var_accessor
    @mock.verify
  end

  it "is able to execute instance methods" do
    @mock.expect :deferred, nil, ["inst_method"]
    @defer.defers_method
    @mock.verify
  end
end
