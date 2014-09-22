$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "access_control/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "access_control"
  s.version     = AccessControl::VERSION
  s.authors     = ["Haziman Hashim"]
  s.email       = ["haziman@abh.my"]
  s.homepage    = "http://github.com/jimanx2/"
  s.summary     = "Access Control Level tool"
  s.description = "This plugin/gem enables ACL functionality that will give you (super admin) control down to HTML element's level"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails",">4.0.0" 
  s.add_dependency "devise"
  s.add_dependency "jquery-rails"
  
end
