Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, except: [:edit, :update]
  resources :members, except: [:edit, :update]

  post 'login', to: 'sessions#login'
end
