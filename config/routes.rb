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
    resources :study, :only => [:index]
  end

  resources :components do
    member do
      get :describe
    end
  end

  resources :videos, :only => [:create, :update, :destroy, :edit]
  resources :enrollments, :only => [:create, :update, :destroy]

  resources :memories do
    member do
      get :rate
    end
  end

  resources :quizzes do
    member do
      get :rate_components
    end
  end

  resources :responses, :only => [:create, :update, :edit, :index, :show]

  resources :lessons do
    resources :events
  end

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'
  match '/about', :to => 'pages#about'
  match '/help', :to => 'pages#help'
  match '/home', :to => 'pages#home'
   
  root :to => 'pages#welcome'

end
