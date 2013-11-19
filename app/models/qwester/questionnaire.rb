module Qwester
  class Questionnaire < ActiveRecord::Base
    if Qwester.rails_version == '3'
      attr_accessible :title, :description, :button_image, :question_ids
    end

    has_many(
      :questionnaires_questions, 
      :order => 'position'
    )

    has_many(
      :questions,
      :uniq => true,
      :through => :questionnaires_questions,
      :order => 'position'
    )

    has_many(
      :answers,
      :through => :questions,
      :uniq => true
    )
    accepts_nested_attributes_for :answers

    has_attached_file(
      :button_image,
      :styles => {
        :link => '150x125>',
        :thumbnail => '50x50>'
      }
    )

    has_and_belongs_to_many(
      :answer_stores, 
      :join_table => :qwester_answer_stores_questionnaires,
      :uniq => true
    )
    
    has_many :presentation_questionnaires
    
    has_many(
      :presentations,
      :through => :presentation_questionnaires
    )

    validates :title, :presence => true

    private
    def method_missing(symbol, *args, &block)
      if symbol.to_sym == :position || acts_as_list_method?(symbol)
        pass_acts_as_list_method_to_questionnaires_question(symbol, args.first) 
      else 
        super
      end
    end

  #  Allows acts_as_list methods to be used within the questionnaire. 
  #  
  #  Usage: 
  #  
  #       questionnaire.move_to_top(question)
  #       questionnaire.last?(question)
  # 
    def pass_acts_as_list_method_to_questionnaires_question(symbol, question)
      raise "A Question is needed to identify the QuestionnairesQuestion" unless question.kind_of? Question
      questionnaires_question = questionnaires_questions.where(:question_id => question.id).first
      questionnaires_question.send(symbol) if questionnaires_question
    end

    def acts_as_list_method?(symbol)
      ActiveRecord::Acts::List::InstanceMethods.instance_methods.include?(symbol.to_sym)
    end

  end
end
