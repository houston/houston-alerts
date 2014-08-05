$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "houston/alerts/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "houston-alerts"
  s.version     = Houston::Alerts::VERSION
  s.authors     = ["Bob Lail"]
  s.email       = ["bob.lailfamily@gmail.com"]
  s.homepage    = "https://github.com/houstonmc/houston-alerts"
  s.summary     = "A module for Houston to show and facilitate alerts"
  s.description = "TODO: Description of Houston Alerts."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"

  s.add_development_dependency "sqlite3"
end
