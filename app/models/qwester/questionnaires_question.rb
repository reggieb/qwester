module Qwester
  class QuestionnairesQuestion < ActiveRecord::Base
    if Qwester.rails_version == '3'
      attr_accessible :position
    end

    belongs_to :questionnaire
    belongs_to :question

    acts_as_list :scope => :questionnaire
  end
end
