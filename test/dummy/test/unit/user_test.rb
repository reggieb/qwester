require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.find(1)
  end
  
  def test_password
    assert User.authenticate(@user.username, 'password')
  end
  
  def test_user_is_qwester_admin_user_class
    assert_equal(@user, Qwester.admin_user_class.find(@user.id))
  end
  

end
