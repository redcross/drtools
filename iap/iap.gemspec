$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "iap/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "iap"
  s.version     = Iap::VERSION
  s.authors     = ["John Laxson"]
  s.email       = ["jlaxson@mac.com"]
  s.homepage    = "http://github.com/jlaxson"
  s.summary     = "Module for Creating and Managing Incident Action Plans"
  s.description = "Module for Creating and Managing Incident Action Plans"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "paperclip", "~> 4.0.0"
  s.add_dependency "aws-sdk"
  s.add_dependency "assignable_values"
  s.add_dependency 'omniauth-google-oauth2'
  s.add_dependency 'google-api-client'
  s.add_dependency 'prawn'
  s.add_dependency 'prawn-templates'
end
