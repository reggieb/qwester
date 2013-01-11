require_relative '../../test_helper'
module Qwester

  class QuestionnaireTest < ActiveSupport::TestCase
    def setup
      @questionnaire = Questionnaire.find(1)
    end

    # Overriding this method so want to make sure default behaviour still works
    def test_method_missing
      assert_raise NoMethodError do
        @questionnaire.no_such_method
      end
    end
  end
  
end
