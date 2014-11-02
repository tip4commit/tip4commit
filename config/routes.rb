T4c::Application.routes.draw do

  root 'home#index'

  get '/blockchain_info_callback' => "home#blockchain_info_callback", :as => "blockchain_info_callback"

  # reserved routes (rejected pertty url usernames)
  RESERVED_USER_ROUTES_REGEX = /(^(?:(?!^\d+$|\b(sign_in|cancel|sign_up|edit|confirmation|login)\b).)*$)/
  get  '/users/:name/tips'                  => 'tips#index',                  :constraints => {:name    => /\RESERVED_USER_ROUTES_REGEX/}
  get  '/users/:name'                       => 'users#show',                  :constraints => {:name    => /\RESERVED_USER_ROUTES_REGEX/}

  get  '/:service/:repo/edit'               => 'projects#edit',               :constraints => {:service => /github/, :repo => /.+/}
  get  '/:service/:repo/decide_tip_amounts' => 'projects#decide_tip_amounts', :constraints => {:service => /github/, :repo => /.+/}
  get  '/:service/:repo/tips'               => 'tips#index',                  :constraints => {:service => /github/, :repo => /.+/}
  get  '/:service/:repo/deposits'           => 'deposits#index',              :constraints => {:service => /github/, :repo => /.+/}
  get  '/:service/:repo'                    => 'projects#show',               :constraints => {:service => /github/, :repo => /.+/}

  devise_for :users,
    :controllers => {
      :omniauth_callbacks => "users/omniauth_callbacks"
    }

  resources :users, :only => [:show, :update, :index] do
    collection do
      get :login
    end
    resources :tips, :only => [:index]
  end
  resources :projects, :only => [:show, :index, :edit, :update] do
    collection do
      get 'search'
    end
    member do
      get :decide_tip_amounts
      patch :decide_tip_amounts
    end
    resources :tips, :only => [:index]
    resources :deposits, :only => [:index]
  end
  resources :tips, :only => [:index]
  resources :deposits, :only => [:index]
  resources :withdrawals, :only => [:index]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
