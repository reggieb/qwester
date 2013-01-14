module Qwester
  class AnswerStore < ActiveRecord::Base

    has_and_belongs_to_many(
      :answers,
      :join_table => :qwester_answer_stores_answers,
      :uniq => true
    )
    has_and_belongs_to_many(
      :questionnaires, 
      :join_table => :qwester_answer_stores_questionnaires,
      :uniq => true
    )

    before_save :generate_session_id

    def cope_index_sum
      answers.sum(:cope_index)
    end

    def reset
      answers.clear
      questionnaires.clear
    end

    def to_param
      session_id
    end

    private

    def generate_session_id
      if !self.session_id or self.session_id.empty?
        self.session_id = RandomString.new(15)
      end
    end
  end
end