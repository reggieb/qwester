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
    
    def test_valid_names
      valid = %w{this that foo_bar HeyHo this1 that2 123}
      valid.each do |name|
        @presentation.name = name
        assert(@presentation.save, "#{name} should be a valid  presentation name #{@presentation.errors.full_messages}")
      end
    end
    
    def test_invalid_names
      invalid = ['This and that', 'foo bar', '$this', '@that']
      invalid.each do |name|
        @presentation.name = name
        assert(!@presentation.save, "'#{name}' should be an invalid presentation name")
      end
    end
    
    def test_title_created_from_name
      @presentation.name = "foo_bar"
      @presentation.title = nil
      @presentation.save
      assert_equal('Foo bar', @presentation.title)
    end
    
    def test_set_as_default
      assert !@presentation.default?, "Presentation should not be default at start"
      @presentation.update_attribute(:default, true)
      assert @presentation.default?, "Presentation should be default"
      assert !empty_presentation.reload.default?, "Empty presentation should not be default"
    end
    
    def test_set_as_default_when_other_presentation_default
      test_set_as_default
      empty_presentation.update_attribute(:default, true)
      assert !@presentation.reload.default?, "Presentation should not be default"
      assert empty_presentation.default?, "Empty presentation should be default"
    end
    
    # Overriding this method, so want to make sure default behaviour still works
    # Tests for methods over-riding this are in other test, e.g. questionnaires_question_test.rb
    def test_method_missing
      assert_raise NoMethodError do
        @questionnaire.no_such_method
      end
    end
    
    def empty_presentation
      @empty_presentation ||= Presentation.find(2)
    end
    
  end
end
