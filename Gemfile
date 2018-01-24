source "http://rubygems.org"

# Declare your gem's dependencies in qwester.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# jquery-rails is used by the dummy application
#gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'



# I can't get activeadmin and jquery (which it needs) to work in
# the test/dummy environment without these gem declarations.

gem 'activeadmin'
gem 'bourbon'
group :assets do
  gem 'coffee-script'
  gem 'jquery-rails'
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.10.2', :platforms => :ruby
end

