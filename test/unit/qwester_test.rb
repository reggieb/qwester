require 'test_helper'

class QwesterTest < ActiveSupport::TestCase
  def test_qwester_set_up_as_a_module
    assert_kind_of Module, Qwester
  end
  
  def test_active_admin_load_path
    expected = "#{Qwester::Engine.root}/lib/active_admin/admin"
    assert_equal(expected, Qwester.active_admin_load_path)
  end
  
end
