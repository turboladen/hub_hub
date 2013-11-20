HubHub::Application.routes.draw do
  root 'home#tos'

  devise_for :users
  #devise_for :users, ActiveAdmin::Devise.config

  resources :spokes, only: %i[index show]

  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'

  ActiveAdmin.routes(self)
end
