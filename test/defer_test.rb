require 'test_helper'

class DeferTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Defer::VERSION
  end
end
