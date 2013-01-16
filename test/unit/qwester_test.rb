require 'test_helper'

class QwesterTest < ActiveSupport::TestCase
  
  def setup
    Qwester.active_admin_menu = nil
  end
  
  def test_qwester_set_up_as_a_module
    assert_kind_of Module, Qwester
  end
  
  def test_active_admin_load_path
    expected = "#{Qwester::Engine.root}/lib/active_admin/admin"
    assert_equal(expected, Qwester.active_admin_load_path)
  end
  
  def test_active_admin_menu
    assert_equal('Qwester', Qwester.active_admin_menu)
  end
  
  def test_setting_active_admin_menu
    text = 'Foo'
    Qwester.active_admin_menu = text
    assert_equal(text, Qwester.active_admin_menu)
  end
  
  def test_active_admin_menu_none
    Qwester.active_admin_menu = 'none'
    assert_nil(Qwester.active_admin_menu)
  end
  
end
