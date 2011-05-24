LsAtomic::Application.routes.draw do |map|
  resource :user_session
  resources :users
end
