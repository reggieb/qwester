require 'test_helper'

module Qwester
  class PresentationTest < ActiveSupport::TestCase
    
    def setup
      @questionnaire = Questionnaire.find(1)
      @presentation = Presentation.find(1)
    end
    
    def test_questionnaires
      assert(@presentation.questionnaires.include? @questionnaire)
    end
    
    def test_empty_questionnaires
      assert_equal([], empty_presentation.questionnaires)
    end
    
    def empty_presentation
      Presentation.find(2)
    end
    
  end
end
