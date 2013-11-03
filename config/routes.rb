HubHub::Application.routes.draw do
  root 'home#tos'
  devise_for :users
  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'
end
