module Qwester
  class Questionnaire < ActiveRecord::Base
    attr_accessible :title, :description, :button_image, :question_ids

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

    has_and_belongs_to_many :answer_stores, :uniq => true

    validates :title, :presence => true

    private
    def method_missing(symbol, *args, &block)
      if acts_as_list_method?(symbol)
        pass_method_to_questionnaires_question(symbol, args.first)
      else
        super
      end
    end

  #  Allows acts_as_list methods to be used within the questionnaire. 
  #  If questions were the act_as_list object, you could do things like this
  #   
  #       questionnaire.questions.last.move_higher
  #       
  #   However, as questions are used on multiple questionnaires and they
  #   need to be independently sortable within each questionnaire, it is the
  #   through table model QuestionnairesQuestion that acts_as_list. To change
  #   position the change must be made in the context of the questionnaire. 
  #   pass_method_to_questionnaires_question in combination with method_missing,
  #   allows you to pass to a questionnaire the acts_as_list method together with
  #   the question it needs to effect. The equivalent move_higher call then becomes:
  #   
  #       questionnaire.move_higher(questionnaire.questions.last)
  #       
  #   You can also do:
  #   
  #       questionnaire.move_to_top(question)
  #       questionnaire.last?(question)
  # 
    def pass_method_to_questionnaires_question(symbol, question)
      raise "A Question is needed to identify QuestionnairesQuestion" unless question.kind_of? Question
      questionnaires_question = questionnaires_questions.where(:question_id => question.id).first
      questionnaires_question.send(symbol) if questionnaires_question
    end

    def acts_as_list_method?(symbol)
      ActiveRecord::Acts::List::InstanceMethods.instance_methods.include?(symbol.to_sym)
    end


  end
end
