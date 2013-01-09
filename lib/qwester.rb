require "qwester/engine"

module Qwester
  mattr_accessor :admin_user_class
  
  def self.admin_user_class
    if @@admin_user_class and @@admin_user_class.respond_to? :constantize
      @@admin_user_class.constantize
    else
      raise "You must specify a Qwester.admin_user_class. For example in an initializer"
    end
  end
  
end
