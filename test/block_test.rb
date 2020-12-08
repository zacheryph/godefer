require 'test_helper'

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

  it "runs deferred blocks when exception is raised" do
    begin
      Defer.run do
        defer { puts "1" }
        raise Exception.new("wee")
      end
    rescue Exception
      nil
    end

    assert read_output == "1\n"
  end

  it "bubbles exceptions that happen" do
    assert_raises Exception do
      Defer.run do
        raise Exception.new("wee")
      end
    end
  end

  it "prevents exception bubbling if recovered" do
    Defer.run do
      defer do
        if ex = recover
          puts ex.message
        end
      end

      raise Exception.new("wee")
    end

    assert read_output == "wee\n"
  end

  it "gives nil for recover if no exception" do
    Defer.run do
      defer { puts "3" }

      defer do
        if ex = recover
          puts ex.message
        end
      end

      defer { puts "1" }
    end

    assert read_output == "1\n3\n"
  end
end
