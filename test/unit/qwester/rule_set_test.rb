require_relative '../../test_helper'
module Qwester

  class RuleSetTest < ActiveSupport::TestCase
    def setup
      @rule_set = RuleSet.find(1)
      @answer = Answer.find(1)
      @other_answer = Answer.find(2)
      @rule_set.answers << @answer
    end

    def test_match
      assert(@rule_set.match(@rule_set.answers), "should match if rule_set.answers equal answers passed in")
    end

    def test_match_when_additional_answers_passed_in
      assert(@rule_set.match([@rule_set.answers, @other_answer].flatten), "should match as long as answers passed in include ruleset.answers")
    end

    def test_match_failure
      assert_no_rule_set_match([@other_answer])
    end

    def test_partial_match
      @rule_set.answers << @other_answer
      assert(@rule_set.match([@other_answer]), "should match as long as answers includes @other_answer")
    end

    def test_match_when_no_answers_passed_in
      assert_no_rule_set_match([])
    end

    def test_match_when_nil_passed_in
      assert_no_rule_set_match(nil)
    end

    def test_matches
      create_more_rule_sets
      rule_sets = RuleSet.matching([@answer])
      assert_equal(2, rule_sets.length)
      assert(rule_sets.include?(@rule_set), "RuleSet @rule_set should be included")
      assert(rule_sets.include?(@rule_set_one), "RuleSet one should be included")
      assert(!rule_sets.include?(@rule_set_two), "RuleSet two should not be included")
    end

    def test_matchs_with_where
      create_more_rule_sets
      rule_sets = RuleSet.where(:title => @rule_set.title).matching([@answer])
      assert_equal([@rule_set], rule_sets)
    end

    def test_custom_rule
      create_custom_rule_set('a1 and a2')
      assert(@rule_set.match([@answer, @other_answer]), "Should match as both answers present")
      assert(!@rule_set.match([@answer]), "Should not match as other answer missing") 
    end

    def test_custom_rule_or
      create_custom_rule_set('a1 or a2')
      assert(@rule_set.match([@answer, @other_answer]), "Should match as both answers present")
      assert(@rule_set.match([@answer]), "Should match as answer present")  
    end

    def test_custom_rule_in
      create_custom_rule_set('2 in a1 a2')
      assert(@rule_set.match([@answer, @other_answer]), "Should match as both answers present")
      assert(!@rule_set.match([@answer]), "Should not match as only one answer present")  
    end

    def test_matching_answer_sets
      create_custom_rule_set('a1 and a2')
      assert_equal([[1, 2]], @rule_set.matching_answer_sets)
    end

    def test_blocking_answer_sets
      create_custom_rule_set('a1 and a2')
      assert_equal([[1], [2]], @rule_set.blocking_answer_sets)
    end

    def test_default_rules_created_from_answers_on_create
      rule_set = RuleSet.create(:title => 'One', :answers => [@answer], :url => 'http://undervale.co.uk')
      assert_equal(rule_set.default_rule, rule_set.rule)
      rule_set = RuleSet.create(:title => 'Two', :answers => [@answer, @other_answer], :url => 'http://undervale.co.uk')
      assert_equal(rule_set.default_rule, rule_set.rule)
    end

    def test_default_rule
      assert_equal(@answer.rule_label, @rule_set.default_rule)
      @rule_set.answers << @other_answer
      expected = "#{@answer.rule_label} #{RuleSet::DEFAULT_RULE_JOIN} #{@other_answer.rule_label}"
      assert_equal(expected, @rule_set.default_rule)
    end

    def test_answers_populated_by_rules
      test_custom_rule
      assert_equal([@answer, @other_answer], @rule_set.answers)
    end

    def test_answers_shrink_when_answer_removed_from_rule
      test_answers_populated_by_rules
      @rule_set.rule = 'a1'
      @rule_set.save
      assert_equal([@answer], @rule_set.answers)
    end

    def test_answers_expand_when_answer_added_to_rule
      @rule_set.rule = 'a1 and a2'
      @rule_set.save
      assert_equal([@answer, @other_answer], @rule_set.answers)
    end

    def test_rule_validation
      @rule_set.rule = 'invalid'
      @rule_set.save
      assert(@rule_set.errors[:rule].present?, "there should be an error against the rule field")
    end

    private
    def assert_no_rule_set_match(answers = nil)
      assert(!@rule_set.match(answers), "should not return true if no match found")
    end

    def create_more_rule_sets
      @rule_set_one = RuleSet.create(:title => 'One', :answers => [@answer], :url => 'http://undervale.co.uk')
      @rule_set_two = RuleSet.create(:title => 'Two', :answers => [@other_answer], :url => 'http://undervale.com')
    end

    def create_custom_rule_set(rule)
      @rule_set = RuleSet.create(:title => 'Custom', :rule => rule, :url => 'http://undervale.co.uk')
    end

  end
  
end
