module Qwester
  class Engine < ::Rails::Engine
    isolate_namespace Qwester
    
    initializer 'qwester.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        
        helper Qwester::QuestionnairesHelper
             
      end
    end
  end
end
