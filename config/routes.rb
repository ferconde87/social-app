Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root to: 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :posts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  #google-sign-in
  get 'google_login', to: 'google_logins#new'
  get 'google_login/create', to: 'google_logins#create', as: :google_create_login

  post '/auth/facebook/callback', to: 'sessions#create'
  # post '/auth/facebook/callback', to: 'sessions#create'

end
