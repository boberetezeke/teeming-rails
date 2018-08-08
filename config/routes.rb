Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  namespace :api do
    resources :members
    resources :users
  end

  post 'api/login', to: 'sessions#login'

  resources :jobs
  resources :users, except: [:index] do
    member do
      put :update_email
      put :update_password
    end

    collection do
      get :home
      get :profile
      get :privacy
      get :account
      get :privacy_policy
      get :bylaws
      get :code_of_conduct
      put :redo_initial_steps
      get :with_roles
    end
  end

  resources :roles, only: [:index, :show]

  resources :messages, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  resources :candidacies do
    member do
      put :unlock
    end

    collection do
      get :with_completed_questionnaires
    end
  end
  resources :races, only: [] do
  end
  resources :event_rsvps, only: [:new, :create, :edit, :update]
  resources :events do
    resources :event_sign_ins, shallow: true
    member do
      put :email
      put :publish
      put :unpublish
    end
  end
  resources :member_groups do
    resources :members
  end
  resources :candidate_questionnaires, only: [:edit, :update]

  resources :message_controls, only: [:edit, :update, :show, :create]

  resources :chapters do
    resources :members, only: [:index, :new, :create, :show, :edit, :update, :destroy], shallow: true do
      collection do
        post :import
      end
    end
    resources :events,   shallow: true do
      resources :event_rsvps, only: [:create]
    end
    resources :messages, shallow: true do
      member do
        put :send_to_all
        put :preview_to
      end
    end
    resources :officers, shallow: true
    resources :officer_assignments, shallow: true
    resources :meeting_minutes, shallow: true
  end

  resources :elections do
    member do
      put :freeze
      put :unfreeze
      put :email
    end
    resources :votes, shallow: true, only: [:index, :create] do
      collection do
        get :tallies
        get :raw_votes
        put :generate_tallies
        get :view
        get :wait
        get :missed
        get :disqualified
        get :enter
        get :download_votes
        put :delete_votes
      end
    end
    resources :races, shallow: true do
      member do
        put :create_questionnaire
        put :email_questionnaire
        patch :copy_questionnaire
        delete :delete_questionnaire
      end
    end
    resources :issues, shallow: true do
      member do
        put :create_questionnaire
        delete :delete_questionnaire
      end
    end
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
      resources :candidate_questionnaires, only: [:edit, :update]
      resources :message_controls, only: [:edit, :update, :show, :create]
    end
  end

  authenticated :user do
    root to: 'users#home'
  end
end
