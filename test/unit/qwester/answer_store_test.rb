require_relative '../../test_helper'
module Qwester

  class AnswerStoreTest < ActiveSupport::TestCase

    def setup
      @answer_store = AnswerStore.find(1)
      @answer = Answer.find(1)
      @other_answer = Answer.find(2)
      @questionnaire = Questionnaire.find(1)
    end

    def test_answers_empty
      assert_equal([], @answer_store.answers)
    end

    def test_answer_store_accepts_objects
      @answer_store.answers << @answer
      @answer_store.questionnaires << @questionnaire
      assert_equal([@questionnaire], @answer_store.questionnaires)
      assert_equal([@answer], @answer_store.answers)
    end

    def test_reset
      test_answer_store_accepts_objects
      @answer_store.reset
      assert_equal([], @answer_store.questionnaires)
      assert_equal([], @answer_store.answers)
    end

    def test_session_id_generated_on_creation
      answer_store = AnswerStore.create
      assert_match /^\w*$/, answer_store.session_id
      assert_equal 15, answer_store.session_id.length
    end
    
    def test_preserve
      assert_difference 'AnswerStore.count', 1 do
        @preserved = @answer_store.preserve
      end
      assert(@preserved.preserved?)
      assert(!@answer_store.preserved?)
    end
    
    def test_preserved_is_last_created
      test_preserve
      assert_equal(AnswerStore.last, @preserved)
    end
    
    def test_preserved_answer_store_has_new_session_id
      test_preserve
      assert_not_equal(@answer_store.session_id, @preserved.session_id)
    end
    
    def test_preserved_has_same_objects_as_original
      test_answer_store_accepts_objects
      test_preserve
      assert_equal(@answer_store.answers, @preserved.answers)
      assert_equal(@answer_store.questionnaires, @preserved.questionnaires)
    end
    
    def test_changes_to_original_do_not_affect_preserved
      test_preserve
      assert_equal([], @preserved.answers)
      assert_equal([], @preserved.questionnaires)
      test_answer_store_accepts_objects
      @preserved.reload
      assert_equal([], @preserved.answers)
      assert_equal([], @preserved.questionnaires)
    end

  end
end