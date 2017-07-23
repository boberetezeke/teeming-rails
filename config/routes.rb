Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :members
    resources :users
  end

  post 'api/login', to: 'sessions#login'

  resources :users do
    collection do
      get :home
      get :profile
      get :accept_bylaws
      get :privacy_policy
      put :redo_initial_steps
    end
  end

  resources :events, only: [:index, :show]
  resources :event_rsvps, only: [:new, :create, :edit, :update]
  resources :candidacies

  unauthenticated :user do
    devise_scope :user do
      root 'brochure#home', as: :unauthenticated_root
    end
  end

  authenticated :user do
    root to: 'users#home'
  end
end
