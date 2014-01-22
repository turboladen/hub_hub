HubHub::Application.routes.draw do
  root 'home#index'

  get '/admin/sign_in', to: 'sessions#new', as: 'new_admin_session'
  post '/admin/sign_in', to: 'sessions#create', as: 'admin_sessions'
  delete '/admin/sign_out', to: 'sessions#destroy', as: 'destroy_admin_session'

  ActiveAdmin.routes(self)

  namespace :api, defaults: { format: 'json' } do
    resources :spokes, only: %i[index show]
    resources :posts, except: %i[new edit]

    post '/sessions', to: 'sessions#create'
    delete '/sessions', to: 'sessions#destroy'
    post '/remember', to: 'sessions#remember'

    resources :users, only: %i[create show update destroy]
  end
end
