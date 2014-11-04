T4c::Application.routes.draw do

  root 'home#index'

  get '/blockchain_info_callback' => "home#blockchain_info_callback", :as => "blockchain_info_callback"

  # reserved devise routes (rejected pertty url usernames)
  RESERVED_USER_ROUTES_REGEX = /(^(?:(?!^\d+$|\b(sign_in|cancel|sign_up|edit|confirmation|login)\b).)*$)/
  get  '/users/:name/tips'                  => 'tips#index',                  :constraints => {:name       => /\RESERVED_USER_ROUTES_REGEX/}
  get  '/users/:name'                       => 'users#show',                  :constraints => {:name       => /\RESERVED_USER_ROUTES_REGEX/}

  get  '/projects/:project_id/tips'         => 'tips#index',                  :constraints => {:project_id => /\d+/}, :as => 'project_tips'
  get  '/projects/:project_id/deposits'     => 'deposits#index',              :constraints => {:project_id => /\d+/}, :as => 'project_deposits'
  get  '/:service/:repo/edit'               => 'projects#edit',               :constraints => {:service    => /github/, :repo => /.+/}
  get  '/:service/:repo/decide_tip_amounts' => 'projects#decide_tip_amounts', :constraints => {:service    => /github/, :repo => /.+/}
  get  '/:service/:repo/tips'               => 'tips#index',                  :constraints => {:service    => /github/, :repo => /.+/}, :as => 'project_tips_pretty'
  get  '/:service/:repo/deposits'           => 'deposits#index',              :constraints => {:service    => /github/, :repo => /.+/}, :as => 'project_deposits_pretty'
  get  '/:service/:repo'                    => 'projects#show',               :constraints => {:service    => /github/, :repo => /.+/}

  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

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
      get   :decide_tip_amounts
      patch :decide_tip_amounts
    end
  end
  resources :tips, :only        => [:index]
  resources :deposits, :only    => [:index]
  resources :withdrawals, :only => [:index]

  get '*path' => 'home#index'
end
