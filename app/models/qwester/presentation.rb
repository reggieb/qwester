module Qwester
  class Presentation < ActiveRecord::Base
    attr_accessible :description, :name, :title, :questionnaire_ids, :default
    
    has_many(
      :presentation_questionnaires,
      :order => 'position'
    )
    
    has_many(
      :questionnaires,
      :through => :presentation_questionnaires,
      :order => 'position'
    )
    accepts_nested_attributes_for :questionnaires
    
    before_save :before_save_tasks
    after_save :after_save_tasks
    
    validates(
      :name, 
      :format => { 
        :with => /^\w+$/, 
        :message => "must comprise letters or numbers with underscores separating words"
      },
      :presence => true,
      :uniqueness => true
    )
    
    private
    def before_save_tasks
      update_title_from_name
    end
    
    def after_save_tasks
      undefault_others if self.default?
    end
    
    def undefault_others
      current_defaults = self.class.find_all_by_default(true)
      current_defaults.each{|p| p.update_attribute(:default, false) unless p == self}
    end
    
    def update_title_from_name
      self.title = self.name.humanize unless self.title.present?
    end
    
    def method_missing(symbol, *args, &block)
      if acts_as_list_method?(symbol)
        pass_acts_as_list_method_to(presentation_questionnaires, symbol, args.first)
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
    def pass_acts_as_list_method_to(presentation_questionnaires, symbol, questionnaire)
      raise "A Questionnaire is needed to identify the PresentationQuesti" unless questionnaire.kind_of? Questionnaire
      presentation_questionnaire = presentation_questionnaires.where(:questionnaire_id => questionnaire.id).first
      presentation_questionnaire.send(symbol) if presentation_questionnaire
    end

    def acts_as_list_method?(symbol)
      ActiveRecord::Acts::List::InstanceMethods.instance_methods.include?(symbol.to_sym)
    end
    
  end
end
