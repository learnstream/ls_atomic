LsAtomic::Application.routes.draw do 

  resources :notes
  resources :events

  resources :user_sessions
  resources :users do
    member do
      get :courses
    end
  end

  resources :courses do
    resources :lessons
    resources :quizzes
    resources :components
    member do
      get :users
      get :success_stats
      get :cards_due_stats
      get :course_achieved_stats
      get :student_status
    end
    resources :study, :only => [:index, :show]
    resources :memories, :only => [:index, :update] 
  end

  resources :components 

  resources :videos, :only => [:create, :update, :destroy, :edit]
  resources :enrollments, :only => [:create, :update, :destroy]

  resources :memories
  resources :quizzes
  resources :responses, :only => [:create, :update, :edit, :index, :show]

  resources :lessons do
    resources :events
  end

  resources :lesson_statuses
  resources :authentications

  match '/auth/:provider/callback' => 'authentications#create'

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/home', :to => 'pages#home'
   
  root :to => 'pages#welcome'

  resources :lesson_components, :only => [:update, :create, :destroy]

end
