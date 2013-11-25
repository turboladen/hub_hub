HubHub::Application.routes.draw do
  root 'home#index'

  resources :spokes, only: %i[index show], defaults: { format: 'json' }
  resources :posts, except: %i[new edit], defaults: { format: 'json' }

  devise_for :users
  #devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
end
