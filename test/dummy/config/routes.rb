Rails.application.routes.draw do
  
  root :to => 'qwester/questionnaires#index'

  if defined?(ActiveAdmin)
    ActiveAdmin.routes(self)
    devise_for :admin_users, ActiveAdmin::Devise.config
  end

  mount Qwester::Engine => "/questionnires"
  

end
