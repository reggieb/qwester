module Qwester
  class PresentationQuestionnaire < ActiveRecord::Base
    attr_accessible :presentation_id, :questionnaire_id
    
    belongs_to :presentation
    belongs_to :questionnaire
    
    acts_as_list :scope => :presentation
  end
end
