Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :members
    resources :users
  end

  post 'api/login', to: 'sessions#login'

  resources :users do
    collection do
      get :profile
      get :accept_bylaws
      get :home
    end
  end

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
