module Qwester
  class Presentation < ActiveRecord::Base
    attr_accessible :description, :name, :title, :questionnaire_ids, :default
    
    has_many :presentation_questionnaires
    
    has_many(
      :questionnaires,
      :through => :presentation_questionnaires
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
    
  end
end
