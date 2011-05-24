LsAtomic::Application.routes.draw do |map|
  get "pages/home"

  get "pages/about"

  get "pages/help"

  resource :user_session
  resources :users
end
