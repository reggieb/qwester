module Qwester
  class PresentationQuestionnaire < ActiveRecord::Base
    if Qwester.rails_version == '3'
      attr_accessible :presentation_id, :questionnaire_id
    end
    
    belongs_to :presentation
    belongs_to :questionnaire
    
    acts_as_list :scope => :presentation
  end
end
