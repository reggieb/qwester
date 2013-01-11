module Qwester
  class QuestionnairesQuestion < ActiveRecord::Base
    attr_accessible :position

    belongs_to :questionnaire
    belongs_to :question

    acts_as_list :scope => :questionnaire
  end
end
