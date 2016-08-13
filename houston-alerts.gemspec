$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "houston/alerts/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "houston-alerts"
  spec.version     = Houston::Alerts::VERSION
  spec.authors     = ["Bob Lail"]
  spec.email       = ["bob.lailfamily@gmail.com"]

  spec.summary     = "A module for Houston to show and facilitate alerts"
  spec.description = "A module for Houston to show and facilitate alerts"
  spec.homepage    = "https://github.com/houston/houston-alerts"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]
  spec.test_files = Dir["test/**/*"]

  spec.add_dependency "houston-core", ">= 0.8.0.pre"

  spec.add_development_dependency "bundler", "~> 1.11.2"
  spec.add_development_dependency "rake", "~> 11.2"
end
