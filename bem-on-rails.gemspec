# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bem-on-rails/version'

Gem::Specification.new do |spec|
  spec.name          = "bem-on-rails"
  spec.version       = Bemonrails::VERSION
  spec.authors       = ["Anton Winogradov"]
  spec.email         = ["winogradovaa@gmail.com"]
  spec.description   = %q{Gem for work with BEM methodology in Rails applications}
  spec.summary       = %q{BEM Tools for Rails applications}
  spec.homepage      = "https://github.com/verybigman/bem-on-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "thor", "~> 0.16"
  spec.add_dependency "activesupport"
end
