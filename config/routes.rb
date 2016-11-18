Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  namespace :admin do 
    resources :projects, only: :index
  end
  
  resources :projects do
    resources :tasks do
      member do
        get :include
        get :exclude        
      end
    end
    collection do
      get :find
    end
    member do
      get :select_tasks
      get :all_tasks
      get :unassign_user
    end
  end
  
end
