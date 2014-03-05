$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dashboard/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dashboard"
  s.version     = Dashboard::VERSION
  s.authors     = ["John Laxson"]
  s.email       = ["jlaxson@mac.com"]
  s.homepage    = "http://github.com/jlaxson"
  s.summary     = "Simple financial and statistical dashboard for DROs"
  s.description = "Simple financial and statistical dashboard for DROs"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_dependency "dsars"
end
