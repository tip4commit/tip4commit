T4c::Application.routes.draw do

  root 'home#index'

  get '/blockchain_info_callback' => "home#blockchain_info_callback", :as => "blockchain_info_callback"

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
  resources :projects, :only => [:show, :index, :create, :edit, :update] do
    collection do
      get 'by_watchers'
    end
    member do
      get :decide_tip_amounts
      patch :decide_tip_amounts
    end
    resources :tips, :only => [:index]
  end
  resources :tips, :only => [:index]
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
