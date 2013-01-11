require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  
  def setup
    @admin_user = AdminUser.find(1)
  end
  
end
