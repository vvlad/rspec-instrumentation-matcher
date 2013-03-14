# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec-instrumentation-matcher/version'

Gem::Specification.new do |gem|
  gem.name          = "rspec-instrumentation-matcher"
  gem.version       = Rspec::Instrumentation::Matcher::VERSION
  gem.authors       = ["Vlad Verestiuc"]
  gem.email         = ["vlad.verestiuc@me.com"]
  gem.description   = %q{Rspec matcher for ActiveSupport::Notifications}
  gem.summary       = %q{Rspec matcher for ActiveSupport::Notifications}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rspec-expectations'
  gem.add_dependency 'activesupport'
end
