LsAtomic::Application.routes.draw do |map|
  #get "courses/new"

  #get "courses/show"

  #get "courses/create"
#  post "problems/create"

  resources :user_sessions
  resources :users
  resources :courses
  resources :components
  resources :problems 

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/db', :to => 'components#list', :as => 'db'
  
  root :to => 'pages#home'

end
