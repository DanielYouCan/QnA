Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  resources :questions do
    resources :answers, only: %i[create destroy update], shallow: true do
      member do
        patch :set_best
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

  mount ActionCable.server => '/cable'
end
