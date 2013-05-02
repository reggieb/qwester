require 'test_helper'

module Qwester
  class PresentationQuestionnaireTest < ActiveSupport::TestCase
    
    def setup
      @presentation_questionnaire = PresentationQuestionnaire.find(1)
      @questionnaire = Questionnaire.find(2)
      @presentation = @presentation_questionnaire.presentation
      @presentation.questionnaires << @questionnaire
      @default_order = [@presentation_questionnaire.questionnaire, @questionnaire]
    end
    
    def test_setup
      assert_kind_of(Questionnaire, @presentation_questionnaire.questionnaire)
      assert_not_equal(@questionnaire, @presentation_questionnaire.questionnaire)
      assert_equal(@default_order, @presentation.questionnaires)
    end
    
    def test_acts_as_list_method_last
      assert_equal(true, @presentation.last?(@questionnaire))
      assert_equal(false, @presentation.last?(@presentation_questionnaire.questionnaire))
    end
    
    def test_acts_as_list_method_move_to_top
      @presentation.move_to_top(@questionnaire)
      assert_equal(@default_order.reverse, @presentation.questionnaires)
    end
    
  end
end
