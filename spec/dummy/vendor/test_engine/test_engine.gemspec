$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "test_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "test_engine"
  s.version     = TestEngine::VERSION
  s.authors     = [" Your name"]
  s.email       = ["Your email"]
  s.homepage    = "http://www.google.com"
  s.summary     = "Summary of TestEngine."
  s.description = "Description of TestEngine."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

end
