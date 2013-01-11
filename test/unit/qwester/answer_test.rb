require 'test_helper'

module Qwester

  class AnswerTest < ActiveSupport::TestCase
    def setup
      @answer = Answer.find(1)
    end

    def test_find_first_or_create
      answer = Answer.find_first_or_create(
        :value => @answer.value,
        :question_id => @answer.question_id
      )
      assert_equal(@answer, answer)
    end

    def test_find_first_or_create_when_answer_does_not_exist
      new_value = 'something'
      assert_difference 'Answer.count' do
        answer = Answer.find_first_or_create(
          :value => 'something',       
          :question_id => Question.first.id
        )
      end
      assert_equal(new_value, Answer.last.value)
    end

    def test_destroy
      rule_set = RuleSet.first
      answer_store = AnswerStore.first
      @answer.rule_sets = [rule_set]
      @answer.answer_stores = [answer_store]
      assert_difference 'Answer.count', -1 do
        assert_difference 'rule_set.answers.count', -1 do
          assert_difference 'answer_store.answers.count', -1 do
            @answer.destroy
          end
        end
      end
    end

    def test_rule_label
      assert_equal("a#{@answer.id}", @answer.rule_label)
    end
  end
end
