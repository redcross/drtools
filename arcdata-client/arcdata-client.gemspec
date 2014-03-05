$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "arc_data/client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "arcdata-client"
  s.version     = ARCData::Client::VERSION
  s.authors     = ["John Laxson"]
  s.email       = ["jlaxson@mac.com"]
  s.homepage    = "https://github.com/jlaxson"
  s.summary     = "API Client for ARCData"
  s.description = "API Client for ARCData"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"

end
