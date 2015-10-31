# Godefer

[![Build Status](https://travis-ci.org/zacheryph/godefer.svg?branch=master)](https://travis-ci.org/zacheryph/godefer)
[![Code Climate](https://codeclimate.com/github/zacheryph/godefer/badges/gpa.svg)](https://codeclimate.com/github/zacheryph/godefer)
[![Test Coverage](https://codeclimate.com/github/zacheryph/godefer/badges/coverage.svg)](https://codeclimate.com/github/zacheryph/godefer/coverage)

Godefer implements the `defer` / `recover` mechanism from [Go](https://golang.org).  It allows grouping operations together that require a closing of some sort after opening.  I don't really know the usefulness of this gem, though I will take issues and pull requests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'godefer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install godefer

## Usage

Godefer allows two different uses.  The first using a general block, which would mostly be useful probably writing one off scripts of some sort.  The other is to include the `Defer` module into your own class and running code within a `with_defer` block.

### Block Usage

Example of writing to an output file.  The `defer {}` block gets called at the end of the run block.

```ruby
Defer.run do
  f = File.open('output.log')
  defer { f.close }

  # do stuff that uses f
end
```

Deferred blocks are handled in a LIFO ordering, to ensure any operations work their way _back up_ to ensure any dependencies are closed out properly.

```ruby
Defer.run do
  puts "opening"
  defer { puts "closing" }
  puts "start filter"
  defer { puts "stop filter" }
  # ...
end

# Output:
#   opening
#   start filter
#   stop filter
#   closing
```

### Module Usage

Similar example where we are doing a bunch of stuff within a class.

```ruby
class Audit
  include Defer
  attr_accessor :file

  def large_operation
    with_defer do
      opening
      defer { closing }

      helper
      # ...
    end
  end

  def opening ; "..." ; end
  def helper  ; "..." ; end
  def closing ; "..." ; end
end
```

### Recovering Exceptions

Exceptions raised can be recovered within a deferred block.  If an exception is recovered within a defer block, the exception is stopped.  If an exception is raised, and `recover` is not called in a deferred method the exception will be raised from the `Defer.run` or `with_defer` block.  All Deferred blocks reached get called regardless of an exception being raised or not.

```ruby
Defer.run do
  defer do
    if ex = recover
      puts "We stopped an exception: #{ex}"
    end
  end

  raise StandardError.new("Important Message")
end
# Output:
#   We stopped an exception: Important Message

Defer.run do
  defer { puts "see" }
  raise StandardError.new("Error")
end
# Output:
#   see
#
# => StandardError: Error
# => from (pry):3:in `block in __pry__'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zacheryph/godefer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.
