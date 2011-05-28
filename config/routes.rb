LsAtomic::Application.routes.draw do |map|
#  get "step_components/create"

 # get "step_components/destroy"

  #get "courses/new"

  #get "courses/show"

  #get "courses/create"
  #post "problems/create"

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
  resources :problems 
  resources :enrollments, :only => [:create, :destroy]
  resources :steps
  resources :step_components

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/db', :to => 'components#list', :as => 'db'
  
  root :to => 'pages#home'

end
