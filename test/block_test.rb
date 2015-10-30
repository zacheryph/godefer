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

  it "runs deferred blocks last" do
    Defer.run do
      defer { puts "2" }
      puts "1"
    end

    assert read_output == "1\n2\n"
  end

  it "runs deferred blocks in FIFO order" do
    Defer.run do
      defer { puts "4" }
      puts "1"
      defer { puts "3" }
      puts "2"
    end

    assert read_output == "1\n2\n3\n4\n"
  end
end
