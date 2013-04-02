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
    
    def test_set_weighting_alias
      name = :new_alias_method
      assert(!Answer.instance_methods.include?(name.to_sym), "Answer methods should not include #{name} at start of test")
      Answer.weighting_alias = name
      assert_equal(name, Answer.weighting_alias)
      assert(Answer.instance_methods.include?(name.to_sym), "Set weighting alias should define instance method #{name} ")
      weighting = 4
      @answer.weighting = weighting
      assert_equal(weighting, @answer.send(name))
      remove_weighting_alias
    end
    
    def test_remove_weighting_alias
      Answer.weighting_alias = :something
      remove_weighting_alias
    end
    
    def test_setting_weighting_alias_to_nil_removes_existing_alias
      name = :new_alias_method
      Answer.weighting_alias = name
      Answer.weighting_alias = nil
      assert(!Answer.instance_methods.include?(name), "Answer methods should not include #{name}")
      assert_nil(Answer.weighting_alias)
    end
    
    def test_weighting_alias_name
      assert_equal('weighting', Answer.weighting_alias_name)
      name = 'something_weighty'
      Answer.weighting_alias = name
      assert_equal(name, Answer.weighting_alias_name)
    end
    
    private
    def remove_weighting_alias
      name = Answer.weighting_alias.to_sym
      Answer.remove_weighting_alias
      assert(!Answer.instance_methods.include?(name), "Answer methods should not include #{name}")
      Answer.class_eval "@weighting_alias = nil"
      assert_nil(Answer.weighting_alias)
    end
    
  end
end
