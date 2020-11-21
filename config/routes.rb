T4c::Application.routes.draw do
  root 'home#index'

  devise_for :users,
             :controllers => { :omniauth_callbacks => 'users/omniauth_callbacks' }

  get '/users/login'                       => 'users#login', :as => 'login_users'
  get '/users/:user_id/tips'               => 'tips#index',                    :constraints => { :user_id    => /\d+/ }, :as => 'user_tips'
  get '/users/:nickname/tips'              => 'tips#index',                    :constraints => { :nickname   => /\w[\d\w\-]*/ }, :as => 'user_tips_pretty'
  get '/users/:id'                         => 'users#show',                    :constraints => { :id         => /\d+/ }, :as => 'user'
  get '/users/:nickname'                   => 'users#show',                    :constraints => { :nickname   => /\w[\d\w\-]*/ }, :as => 'user_pretty'

  get '/projects/:project_id/tips'         => 'tips#index',                    :constraints => { :project_id => /\d+/ }, :as => 'project_tips'
  get '/projects/:project_id/deposits'     => 'deposits#index',                :constraints => { :project_id => /\d+/ }, :as => 'project_deposits'
  get '/:service/:repo/edit'               => 'projects#edit',                 :constraints => { :service    => /github/, :repo => /.+/ }, :as => 'project_edit_pretty'
  get '/:service/:repo/decide_tip_amounts' => 'projects#decide_tip_amounts',   :constraints => { :service    => /github/, :repo => /.+/ }, :as => 'project_decide_tips_pretty'
  get '/:service/:repo/tips'               => 'tips#index',                    :constraints => { :service    => /github/, :repo => /.+/ }, :as => 'project_tips_pretty'
  get '/:service/:repo/deposits'           => 'deposits#index',                :constraints => { :service    => /github/, :repo => /.+/ }, :as => 'project_deposits_pretty'
  get '/:service/:repo'                    => 'projects#show',                 :constraints => { :service    => /github/, :repo => /.+/ }, :as => 'project_pretty'

  resources :tips, :only => [:index]
  resources :deposits, :only => [:index]
  resources :withdrawals, :only => [:index]
  resources :users, :only => [:index, :show, :update, :destroy]
  resources :projects, :only => [:index, :show, :update, :edit ] do
    collection do
      get 'search'
    end
    member do
      get   :decide_tip_amounts
      patch :decide_tip_amounts
    end
  end

  get '*path' => 'home#index'
end
