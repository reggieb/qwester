# Load the rails application
require File.expand_path('../application', __FILE__)

# Load elements needed for active admin to work in dummy

require 'action_controller'
require 'active_support/log_subscriber'
require 'inherited_resources'
require 'devise'

# Initialize the rails application
Dummy::Application.initialize!
