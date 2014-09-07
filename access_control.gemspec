$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "access_control/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "access_control"
  s.version     = AccessControl::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of AccessControl."
  s.description = "TODO: Description of AccessControl."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.1"
  s.add_dependency "sqlite3"
  s.add_dependency "devise"
  s.add_dependency "jquery-rails"
  
end
