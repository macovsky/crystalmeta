# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crystal/version'

Gem::Specification.new do |gem|
  gem.name          = "crystalmeta"
  gem.version       = Crystal::VERSION
  gem.authors       = ["Max Savchenko"]
  gem.email         = ["robotector@gmail.com"]
  gem.description   = %q{Crystal clean meta tags for Rails applications. Support I18n. Perfect for OpenGraph.}
  gem.summary       = %q{Crystalmeta helps you control meta tags through I18n and/or manually. It plays well with OpenGraph.}
  gem.homepage      = "http://github.com/macovsky/crystalmeta"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("rails", ">= 3.0.0")
  gem.add_development_dependency 'rspec-rails', '~> 2.12'
  gem.add_development_dependency 'capybara', '~> 2.0.1'
end
