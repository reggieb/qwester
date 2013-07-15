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
  s.summary     = "Questionnaire engine with configurable questions and answers"
  s.description = "Questionnaires have many questions. Questions have many answers. Answers match Rule Sets. Qwester manages these objects and the relationships that join them."
  s.license     = "MIT-LICENSE"
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "paperclip", "~> 3.0"   # Adds attachment functions
  s.add_dependency "array_logic", "~> 0.2.4" # logic engine used in rule sets
  s.add_dependency 'acts_as_list'
  
  s.add_development_dependency "dibber"  # Used for seeding in test/dummy
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'activeadmin'
  s.add_development_dependency 'sass-rails',   '~> 3.2.3'
  s.add_development_dependency 'uglifier', '>= 1.0.3'
  s.add_development_dependency 'jquery-ui-rails'
  s.add_development_dependency 'jquery-rails'
  s.add_development_dependency 'inherited_resources'
end
