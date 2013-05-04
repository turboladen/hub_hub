HubHub::Application.routes.draw do
  root :to => 'home#index', as: 'home'

  devise_for :users, :controllers => { :registrations => 'registrations' }
  get 'home/index'

  post 'votes/upvote'
  post 'votes/downvote'

  resources :spokes, only: [:show, :new, :edit, :create, :update] do
    resources :posts, only: [:create, :show, :edit, :update, :flag] do
      put :flag

      resources :comments, only: [:create, :edit, :update, :destroy, :flag] do
        put :flag
      end
    end
  end

  get 'tos' => 'home#tos'
  get 'faq' => 'home#faq'

  namespace :admin do
    get '/',          action: :index
    resources :users, only: [:index, :edit, :update]
    resources :settings, only: [:index, :create]

    get :inappropriate_items
  end
end
