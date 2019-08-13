Rails.application.routes.draw do

  root 'static_pages#home'
  post '/posts',  to: 'posts#index'
  get  '/posts',  to: 'posts#index'
  get  '/post' ,  to: 'posts#new'
  post '/post' ,  to: 'posts#create'
  get  '/login',  to: 'sessions#new'
  post '/login',  to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'
  resources :users, only: [:new, :create]
end
