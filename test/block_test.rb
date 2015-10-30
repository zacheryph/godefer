require 'minitest/autorun'

def read_output
  $stdout.rewind
  $stdout.read
end

describe Defer do
  before do
    $stdout = StringIO.new
  end

  it "calls deferred blocks" do
    Defer.run do
      defer { puts "deferred" }
    end

    assert read_output == "deferred\n"
  end
end
