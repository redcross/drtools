$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dsars/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dsars"
  s.version     = Dsars::VERSION
  s.authors     = ["John Laxson"]
  s.email       = ["john.laxson@redcross.org"]
  s.homepage    = "http://github.com/jlaxson"
  s.summary     = "Database Client and Viewer for DSARS Data"
  s.description = "Database Client and Viewer for DSARS Data"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency 'squeel', "~> 1.1"
  s.add_dependency 'httparty'
  s.add_dependency 'nokogiri'
  s.add_dependency 'haml-rails'
  s.add_dependency 'sass-rails'
  s.add_dependency 'activerecord-import'
  s.add_dependency 'googlecharts'
end
