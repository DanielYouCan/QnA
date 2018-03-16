Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  resources :questions do
    member do
      post :subscribe
      delete :unsubscribe
    end
    resources :answers, only: %i[create destroy update], shallow: true do
      member do
        patch :set_best
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  concern :votable do
    member do
      patch :rating_up
      patch :rating_down
      patch :cancel_vote
    end
  end

  resources :attachments, only: :destroy
  resources :questions, :answers, concerns: [:votable] do
    resources :comments, only: %i[create destroy update], shallow: true
  end

  get :set_authorization_confirmed, to: 'authorizations#set_confirmed'

  namespace :users do
    get :set_email
    post :create_user
  end

  mount ActionCable.server => '/cable'
end
