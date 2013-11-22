HubHub::Application.routes.draw do
  root 'home#index'

  resources :spokes, only: %i[index show] do
    resources :posts, except: %i[index]
  end

  devise_for :users
  #devise_for :users, ActiveAdmin::Devise.config

  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'

  ActiveAdmin.routes(self)
end
