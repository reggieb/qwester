require_relative '../../test_helper'
module Qwester

  class QuestionnaireTest < ActiveSupport::TestCase
    def setup
      @questionnaire = Questionnaire.find(1)
    end

    # Overriding this method, so want to make sure default behaviour still works
    # Tests for methods over-riding this are in other test, e.g. questionnaires_question_test.rb
    def test_method_missing
      assert_raise NoMethodError do
        @questionnaire.no_such_method
      end
    end
    
    def test_habtm_joins_to_answer_store
      @questionnaire.answer_stores << AnswerStore.first
    end
    
    def test_presentation
      assert_equal([Presentation.find(1)], @questionnaire.presentations)
    end
  end
  
end
