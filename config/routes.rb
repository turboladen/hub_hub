HubHub::Application.routes.draw do
  root :to => 'home#index', as: 'home'

  devise_for :users, :controllers => { :registrations => "registrations" }
  get "home/index"
  get "home/tos"

  namespace :admin do
    get "/",          action: :index

    get "users",      action: :index_users, as: 'users'
    get "users/:id",  action: :show_user, as: 'user'
    put "users/:id",  action: :update_user

    get :inappropriate_items
    get :digest_email_settings, action: :edit_digest_email_settings,
      as: :edit_digest_email_settings
    put :digest_email_settings, action: :update_digest_email_settings,
      as: :update_digest_email_settings
  end

  resources :spokes, except: :index do
    resources :posts, except: [:index, :new, :update] do
      put :flag

      resources :comments, except: [:index, :new] do
        put :flag
      end
    end
  end

  post "votes/upvote"
  post "votes/downvote"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
