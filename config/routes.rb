Rails.application.routes.draw do
  # devise_for :users
  namespace :api do
    namespace :v1 do
      resources :users
      resources :articles
      resources :sessions, only: [:create, :destroy]
      post '/login', to: 'auth#login'
      get '/auto_login', to: 'auth#auto_login'
      get '/user_is_authed', to: 'auth#user_is_authed'
    end
  end
end
