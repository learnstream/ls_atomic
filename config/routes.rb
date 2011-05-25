LsAtomic::Application.routes.draw do |map|
  #get "courses/new"

  get "courses/show"

  #get "courses/create"

  resources :user_sessions
  resources :users
  resources :courses

  get "users/new"
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  
  root :to => 'pages#home'

end
