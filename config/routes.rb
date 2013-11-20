HubHub::Application.routes.draw do
  root 'home#tos'

  resources :spokes, only: %i[index show]

  devise_for :users
  #devise_for :users, ActiveAdmin::Devise.config

  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'

  ActiveAdmin.routes(self)
end
