require_relative '../../test_helper'
module Qwester

  class QuestionnairesQuestionTest < ActiveSupport::TestCase
    def setup
      @questionnaires_question = QuestionnairesQuestion.find(1)
      @questionnaire = @questionnaires_question.questionnaire
      @question = Question.find(2)
    end

    def test_setup
      assert_not_equal(@questionnaires_question.question, @question)
    end

    def test_position
      @questionnaire.questions << @question
      assert_equal(1, @questionnaires_question.position)
      assert_equal(2, QuestionnairesQuestion.last.position)
    end

    def test_move_question_up
      test_position
      @questionnaire.move_higher(@question)
      assert_equal(2, @questionnaires_question.reload.position)
      assert_equal(1, QuestionnairesQuestion.last.position)    
    end

    def test_second_questionnaire_not_affected_by_positioning_in_first
      questionnaire = Questionnaire.find(2)
      question = Question.find(1)
      questionnaire.questions << question
      questionnaire.questions << @question
      assert_not_equal(@questionnaire, questionnaire, "should be working with two questionnaires")
      assert_equal([question, @question], questionnaire.questions)
      assert_equal([question], @questionnaire.questions)
      test_move_question_up
      assert_equal([question, @question], questionnaire.reload.questions)
      assert_equal([@question, question], @questionnaire.reload.questions)
    end

    def test_adding_question_again_does_not_create_duplicates
      @questionnaire.questions << @question
      assert_no_difference '@questionnaire.questions.count' do
        @questionnaire.reload.questions << @question
      end
    end

    def test_removing_quesition
      test_adding_question_again_does_not_create_duplicates
      @questionnaire.questions.delete(@question)
      assert_equal(1, @questionnaire.questions.count)
    end

    def test_removing_question_deletes_questionnaires_question_but_does_not_delete_question
      assert_no_difference 'Question.count' do
        assert_difference 'QuestionnairesQuestion.count', -1 do
          @questionnaire.questions.delete(@questionnaire.questions.first)
        end
      end
    end
  end
end
