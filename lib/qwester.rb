require "qwester/engine"
require 'acts_as_list'
require 'paperclip'
require 'random_string'

module Qwester

  def self.active_admin_load_path
    File.expand_path("active_admin/admin", File.dirname(__FILE__))
  end
  
end
