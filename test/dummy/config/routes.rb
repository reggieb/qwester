Rails.application.routes.draw do

  if defined?(ActiveAdmin)
    ActiveAdmin.routes(self)
    devise_for :admin_users, ActiveAdmin::Devise.config
  end

  mount Qwester::Engine => "/qwester"
end
