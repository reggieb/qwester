require_relative '../../test_helper'
module Qwester

  class AnswerStoreTest < ActiveSupport::TestCase

    def setup
      @answer_store = AnswerStore.find(1)
      @answer_store.update_attribute(:updated_at, 2.days.ago)
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
    
    def test_destroy_unpreserved
      assert_not_equal(0, AnswerStore.count)
      AnswerStore.destroy_unpreserved
      assert_equal(0, AnswerStore.count)
    end
    
    def test_destroy_unpreserved_does_not_remove_preserved
      count = AnswerStore.count
      test_preserve
      assert_difference 'AnswerStore.count', - count do
        AnswerStore.destroy_unpreserved
      end
      assert_equal(@preserved, AnswerStore.first)
    end
    
    def test_destroy_unpreserved_does_not_destroy_answers
      test_answer_store_accepts_objects
      assert_no_difference 'Answer.count' do
        AnswerStore.destroy_unpreserved
      end
    end
    
    def test_destroy_unpreserved_does_not_destroy_questionnaires
      test_answer_store_accepts_objects
      assert_no_difference 'Questionnaire.count' do
        AnswerStore.destroy_unpreserved
      end
    end
    
    def test_destroy_unpreserved_removes_entries_from_answers_join_table
      test_answer_store_accepts_objects
      assert_on_destroy_unpreserved_join_entries_removed_for 'answers'
    end
    
    def test_destroy_unpreserved_removes_entries_from_questionnaires_join_table
      test_answer_store_accepts_objects
      assert_on_destroy_unpreserved_join_entries_removed_for 'questionnaires'
    end
    
    def test_destroy_unpreserved_does_not_remove_recent_answer_stores
      answer_store = AnswerStore.create
      AnswerStore.destroy_unpreserved
      assert_equal([answer_store], AnswerStore.all)
    end
    
    def test_restore_preserved
      test_preserve
      assert_difference 'AnswerStore.count' do
        @restored = @preserved.restore
      end
      assert_equal(false, @restored.preserved?)
      assert_not_equal(@preserved.session_id, @restored.session_id)
      assert_equal(@preserved.answers, @restored.answers)
      assert_equal(@preserved.questionnaires, @restored.questionnaires)
    end
    
    def test_get_session_ids
      test_preserve # to populate database with extra answer_stores
      assert_equal(AnswerStore.all.collect(&:session_id).sort, @answer_store.send(:get_session_ids).sort)
    end

    def test_completed_questionnaires
      assert_equal [], @answer_store.completed_questionnaires
      @answer_store.answers << @questionnaire.questions.first.answers.first
      @answer_store.questionnaires << @questionnaire
      assert_equal [@questionnaire], @answer_store.completed_questionnaires
    end

    def test_completed_questionnaires_with_second_question
      first_question = @questionnaire.questions.first
      second_question = Question.find(2)
      second_question.build_standard_answers
      second_question.save
      @questionnaire.questions = [first_question, second_question]
      @answer_store.answers << first_question.answers.first
      @answer_store.questionnaires << @questionnaire
      assert_equal [], @answer_store.completed_questionnaires
      @answer_store.answers << second_question.answers.first
      assert_equal [@questionnaire], @answer_store.completed_questionnaires
    end
    
    private
    def assert_on_destroy_unpreserved_join_entries_removed_for(table)
      join_table = @answer_store.association(table).join_table.name
      sql = "SELECT count(*) FROM #{join_table}"
      original_joins = AnswerStore.connection.select_value(sql)
      AnswerStore.destroy_unpreserved
      joins = AnswerStore.connection.select_value(sql)
      assert_equal(original_joins - 1, joins)
    end

  end
end