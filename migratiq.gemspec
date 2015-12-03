# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'migratiq/version'

Gem::Specification.new do |spec|
  spec.name          = "migratiq"
  spec.version       = Migratiq::VERSION
  spec.authors       = ["Adam Hess"]
  spec.email         = ["adamhess1991@gmail.com"]

  spec.summary       = %q{migrate sidekiq jobs when changing arguments that a worker accepts.}
#  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/HParker/migratiq"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "sidekiq"
end
