LsAtomic::Application.routes.draw do |map|
  resources :user_sessions
  resources :users
  resources :components

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/db', :to => 'components#list'
  
  root :to => 'pages#home'

end
