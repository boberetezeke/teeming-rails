Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  namespace :api do
    resources :members
    resources :users
  end

  post 'api/login', to: 'sessions#login'

  resources :users, except: [:index] do
    member do
      put :update_email
      put :update_password
    end

    collection do
      get :home
      get :profile
      get :account
      get :privacy_policy
      get :bylaws
      get :code_of_conduct
      put :redo_initial_steps
    end
  end

  resources :chapters, only: [:index, :show] do
    resources :members, only: [:index, :show, :edit, :update, :destroy], shallow: true
  end
  resources :elections do
    member do
      put :freeze
      put :unfreeze
    end
    resources :votes, shallow: true, only: [:index, :create] do
      collection do
        get :tallies
        get :view
        get :wait
        get :missed
        get :disqualified
        get :enter
        get :download_votes
        get :generate_tallies
        put :delete_votes
      end
    end
    resources :races, shallow: true do
      member do
        put :create_questionnaire
      end
    end
    resources :issues, shallow: true do
      member do
        put :create_questionnaire
      end
    end
  end
  resources :races, only: [] do
  end
  resources :events, only: [:index, :show]
  resources :event_rsvps, only: [:new, :create, :edit, :update]
  resources :candidacies
  resources :messages, only: [:index, :new, :create, :show, :edit, :update]
  resources :member_groups do
    resources :members
  end

  resources :questionnaires do
    resources :questionnaire_sections, shallow: true do
      member do
        put :move_up
        put :move_down
      end
    end
    resources :questions, shallow: true do
      member do
        put :move_up
        put :move_down
      end
    end
    resources :choices, shallow: true do
      member do
        put :move_up
        put :move_down
      end
    end
  end

  resources :choices, only: [] do
    collection do
      get :new_blank
    end
    member do
      get :move_up
      get :move_down
      get :delete
    end
  end

  unauthenticated :user do
    devise_scope :user do
      root 'brochure#home', as: :unauthenticated_root
    end
  end

  authenticated :user do
    root to: 'users#home'
  end
end
