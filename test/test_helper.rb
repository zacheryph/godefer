require 'simplecov'
require 'simplecov-json'
SimpleCov.start do
  formatter SimpleCov::Formatter::JSONFormatter
end


$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'godefer'

require 'minitest/autorun'

# we use IO to verify things happening properly
def reset_output
  $stdout = StringIO.new
end

def read_output
  $stdout.rewind
  $stdout.read
end
