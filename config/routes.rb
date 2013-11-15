HubHub::Application.routes.draw do
  devise_for :users
  #devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'home#tos'

  resources :spokes

  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'
end
