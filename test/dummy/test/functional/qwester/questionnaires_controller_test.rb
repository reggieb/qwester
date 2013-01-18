require 'test_helper'

module Qwester
  class QuestionnairesControllerTest < ActionController::TestCase
    def setup
      @questionnaire = Questionnaire.find(1)
      @question = Question.find(1)
      @answer = @question.answers.find(1)
    end

    def test_setup
      assert_equal(2, @question.answers.count)
    end

    def test_index
      get :index, :use_route => :qwester
      assert_response :success
      assert_equal(Questionnaire.all, assigns('questionnaires'))
    end

    def test_show
      get :show, :id => @questionnaire.id, :use_route => :qwester
      assert_response :success
      assert_equal(@questionnaire, assigns('questionnaire'))
    end


    def test_update      
      put(
        :update,
        :id => @questionnaire.id,
        :question_id => {
          @question.id.to_s => {
            :answer_ids => [@answer.id.to_s]
          }
        },
        :use_route => :qwester
      )
      answer_store = AnswerStore.last
      assert_equal(@question, @answer.question)
      assert_equal(answer_store.session_id, session[:qwester_answer_store])
      assert_response :redirect
    end
    
    def test_answer_store_created_when_questionnaire_first_submitted
      assert_difference 'AnswerStore.count' do
        test_update
      end
    end

    def test_update_add_multiple_answers
      other_question = Question.find(2)
      other_question.create_standard_answers
      other_answer = other_question.answers.last
      assert_difference 'AnswerStore.count' do
        put(
          :update,
          :id => @questionnaire.id,
          :question_id => {
            @question.id.to_s => {
              :answer_ids => [@answer.id.to_s]
            },
            other_question.id.to_s => {
              :answer_ids => [other_answer.id.to_s]
            }
          },
          :use_route => :qwester
        )
      end
      answer_store = AnswerStore.last

      assert_equal([@answer, other_answer], answer_store.answers)
    end

    def test_update_add_multiple_answers_for_same_question
      answer, other_answer = @question.answers[0..1]
      assert_not_equal(answer, other_answer)
      assert_difference 'AnswerStore.count', 1 do
        put(
          :update,
          :id => @questionnaire.id,
          :question_id => {
            @question.id.to_s => {
              :answer_ids => [answer.id.to_s, other_answer.id.to_s]
            }
          },
          :use_route => :qwester
        )
      end
      answer_store = AnswerStore.last

      assert_equal([answer, other_answer], answer_store.answers)
    end  

    def test_rule_set_match_after_update
      test_update
      rule_set = RuleSet.first
      rule_set.answers << AnswerStore.last.answers.first
      rule_set.save
      get :index, :use_route => :qwester
      assert_equal([rule_set], assigns['rule_sets'])
    end

    def test_reset
      test_update
      assert_no_difference 'Answer.count' do
        get :reset, :use_route => :qwester
        assert_response :redirect
        assert_equal([], AnswerStore.last.answers)
        assert_equal([], AnswerStore.last.questionnaires)
      end
    end

    def test_update_adds_questionnaire_to_answer_store
      test_update
      assert_equal([@questionnaire], AnswerStore.last.questionnaires)
    end
    
    def test_previous_answers_to_question_removed_on_update
      assert_difference 'AnswerStore.count', 1 do
        test_update
      end
      @answer = @question.answers.find(2)
      assert_no_difference 'AnswerStore.count' do
        test_update
      end
    end


  end

end
