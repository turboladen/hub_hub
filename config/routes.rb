HubHub::Application.routes.draw do
  root 'home#index'

  namespace :api, defaults: { format: 'json' } do
    resources :spokes, only: %i[index show]
    resources :posts, except: %i[new edit]
    resources :users, only: %i[show]
  end

  devise_for :users
  #devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
end
