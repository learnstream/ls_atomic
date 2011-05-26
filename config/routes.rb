LsAtomic::Application.routes.draw do |map|
  #get "courses/new"

  #get "courses/show"

  #get "courses/create"

  resources :user_sessions
  resources :users do
    member do
      get :courses
    end
  end
  resources :courses do
    member do
      get :users
    end
  end
  resources :components
  resources :enrollments, :only => [:create, :destroy]

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/db', :to => 'components#list', :as => 'db'
  
  root :to => 'pages#home'

end
