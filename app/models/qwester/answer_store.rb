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
    
    def self.destroy_unpreserved
      where("updated_at < '#{1.day.ago.to_s(:db)}' AND preserved IS NULL").destroy_all
    end

    def reset
      answers.clear
      questionnaires.clear
    end

    def to_param
      session_id
    end
    
    def preserve
      preserved_store = self.class.create({:preserved => Time.now}, :without_protection => true)
      preserved_store.answers = answers
      preserved_store.questionnaires = questionnaires
      return preserved_store if preserved_store.save
    end

    private

    def generate_session_id
      if !self.session_id or self.session_id.empty?
        self.session_id = RandomString.new(15)
      end
    end
  end
end
