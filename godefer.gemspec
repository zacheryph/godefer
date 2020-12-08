# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'defer/version'

Gem::Specification.new do |spec|
  spec.name          = "godefer"
  spec.version       = Defer::VERSION
  spec.authors       = ["Zachery Hostens"]
  spec.email         = ["zacheryph@gmail.com"]
  spec.licenses      = ["MIT"]

  spec.summary       = %q(Go's defer... for Ruby)
  spec.description   = %q(Go's defer functionality in ruby. Never forget to do something.)
  spec.homepage      = "https://github.com/zacheryph/godefer"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.14"
  spec.add_development_dependency "simplecov", "~> 0.20"
  spec.add_development_dependency "simplecov-json", "~> 0.2"
end
