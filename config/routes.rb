Qwester::Engine.routes.draw do
  
  root :to => 'questionnaires#index'
  
  resources :questionnaires, :only => [:index, :show, :update] do
    collection do
      get :reset
    end
  end
  
end
