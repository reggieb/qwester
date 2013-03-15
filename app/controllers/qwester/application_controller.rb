module Qwester
  class ApplicationController < ActionController::Base
    
    def current_questionnaires
      presentation_questionnaires || Qwester::Questionnaire.all
    end
    
    def presentation_questionnaires
      presentation = Qwester::Presentation.find_by_name(session[:presentation])
      presentation.questionnaires if presentation
    end
   
  end
end
