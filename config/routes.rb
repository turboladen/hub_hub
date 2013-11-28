HubHub::Application.routes.draw do
  root 'home#index'

  namespace :api, defaults: { format: 'json' } do
    resources :spokes, only: %i[index show]
    resources :posts, except: %i[new edit]

    post '/sessions', to: 'sessions#create'
    delete '/sessions', to: 'sessions#destroy'

    resources :users, only: %i[create show update destroy]
  end

  ActiveAdmin.routes(self)
end
