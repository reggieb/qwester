$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "qwester/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "qwester"
  s.version     = Qwester::VERSION
  s.authors     = ["Rob Nichols"]
  s.email       = ["rob@undervale.co.uk"]
  s.homepage    = "https://github.com/reggieb/qwester"
  s.summary     = "TODO: Summary of Qwester."
  s.description = "TODO: Description of Qwester."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "mysql2"
end
