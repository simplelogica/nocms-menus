$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "no_cms/menus/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nocms-menus"
  s.version     = NoCms::Menus::VERSION
  s.authors     = ["Simplelogica"]
  s.email       = ["gems@simplelogica.net"]
  s.homepage    = "https://github.com/simplelogica/nocms-menus"
  s.summary     = "Gem with menu functionality independent from any CMS embeddable in any Rails 4 app"
  s.description = "Gem with menu functionality independent from any CMS embeddable in any Rails 4 app"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", '~> 4.0', '>= 4.0.4'
  s.add_dependency "globalize", '~> 4.0', '>= 4.0.0'

  s.add_development_dependency "sqlite3"
end
