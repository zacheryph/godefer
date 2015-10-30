require 'minitest/autorun'

describe Defer do
  before do
    reset_output
  end

  it "calls deferred blocks" do
    Defer.run do
      defer { puts "deferred" }
    end

    assert read_output == "deferred\n"
  end
end
