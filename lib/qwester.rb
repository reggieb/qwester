require "qwester/engine"
require 'acts_as_list'
require 'paperclip'
require 'random_string'
require 'rails/actionpack/lib/action_controller/base'

module Qwester
  
  def self.active_admin_load_path
    File.expand_path("active_admin/admin", File.dirname(__FILE__))
  end
  
  def self.active_admin_menu
    if @active_admin_menu == 'none'
      return nil
    elsif @active_admin_menu
      @active_admin_menu
    else
      'Qwester'
    end
  end
  
  def self.active_admin_menu=(menu)
    @active_admin_menu = menu
  end
  
end
