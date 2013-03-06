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

  end
end