LsAtomic::Application.routes.draw do |map|
  get "users/new"
  match '/signup', :to => 'users#new'

  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  
  root :to => 'pages#home'

  resource :user_session
  resources :users
end
