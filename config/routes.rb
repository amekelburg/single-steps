Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :projects do
    resources :tasks
    collection do
      get :find
    end
    member do
      get :select_tasks
    end
  end
  
end
