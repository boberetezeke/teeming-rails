Rails.application.routes.draw do
  resources :members
  resources :users

  post 'login', to: 'sessions#login'
end
