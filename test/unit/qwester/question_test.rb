require_relative '../../test_helper'
module Qwester

  class QuestionTest < ActiveSupport::TestCase

    def setup
      @question = Question.find(2)
    end

    def test_setup
      assert_equal(0, @question.answers.count)
    end

    def test_build_standard_answers
      assert_no_difference 'Answer.count' do
        @question.build_standard_answers
        assert_question_has_standard_answers
      end
    end

    def test_create_standard_answers
      assert_difference 'Answer.count', Answer.standard_values.length do
        @question.create_standard_answers
        assert_question_has_standard_answers
      end
    end

    def test_destroy
      test_create_standard_answers
      assert_difference 'Question.count', -1 do
        assert_difference 'Answer.count', -(Answer.standard_values.length) do
          @question.destroy
        end
      end
    end

    private
    def assert_question_has_standard_answers
      assert_equal(Answer.standard_values, @question.answers.collect(&:value))
    end
  end
end
