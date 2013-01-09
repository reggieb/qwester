require 'test_helper'

class QwesterTest < ActiveSupport::TestCase
  def test_qwester_set_up_as_a_module
    assert_kind_of Module, Qwester
  end
  
end
