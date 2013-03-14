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
      make_copy({:preserved => Time.now}, :without_protection => true)
    end
    
    def restore
      make_copy
    end

    private

    def generate_session_id
      if !self.session_id or self.session_id.empty?
        self.session_id = session_id_not_in_database
      end
    end
    
    def make_copy(*args)
      copy = self.class.create(*args)
      copy.answers = answers
      copy.questionnaires = questionnaires
      return copy if copy.save
    end
    
    def session_id_not_in_database
      session_ids = get_session_ids
      random_string = RandomString.new(15) until random_string and !session_ids.include?(random_string)
      return random_string
    end
  
    def get_session_ids
      self.class.select(:session_id).collect(&:session_id)
    end
  end
end
