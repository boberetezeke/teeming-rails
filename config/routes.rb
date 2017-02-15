Rails.application.routes.draw do
  resources :candidates
  resources :members
  resources :survey_answers
  resources :surveys
  resources :users

  post 'login', to: 'sessions#login'
end
