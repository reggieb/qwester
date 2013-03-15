module Qwester
  class Presentation < ActiveRecord::Base
    attr_accessible :description, :name, :title
    
    has_many :presentation_questionnaires
    
    has_many(
      :questionnaires,
      :through => :presentation_questionnaires
    )
  end
end
