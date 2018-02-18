Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "questions#index"

  resources :questions do
    resources :answers, only: %i[create destroy update], shallow: true do
      member do
        patch :set_best
      end
    end
  end

  resources :attachments, only: :destroy
end
