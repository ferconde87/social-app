Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root to: 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
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
  resources :comments, only: [:create, :destroy]
  post '/like/:id', to: 'likes#like'
  post '/cancel_like/:id', to: 'likes#cancel_like'
  post '/dislike/:id', to: 'likes#dislike'
  post '/cancel_dislike/:id', to: 'likes#cancel_dislike'
  #google-sign-in
  get 'google_login', to: 'google_logins#new'
  get 'google_login/create', to: 'google_logins#create', as: :google_create_login

  get '/auth/facebook/callback', to: 'facebook_logins#create'
  post '/auth/facebook/callback', to: 'facebook_logins#create'
  get '/auth/facebook/cancelled', to: 'facebook_logins#cancelled'
  post '/auth/twitter', to: 'twitter_logins#create'
  get '/auth/twitter/callback', to: 'twitter_logins#create'
  post '/auth/twitter/callback', to: 'twitter_logins#create'
  get '/auth/twitter/cancelled', to: 'twitter_logins#cancelled'
  get '/contact', to: 'contact#new'
  post 'contact', to: 'contact#create'
end
