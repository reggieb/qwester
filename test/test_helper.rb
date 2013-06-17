# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

puts "fixture path = " + ActiveSupport::TestCase.fixture_path

class ActiveSupport::TestCase
  fixtures :all
end
