# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    resource :session, only: %i[new create destroy]

    root to: 'pages#index'
    resources :users, only: %i[new create edit update]

    shallow do
      resources :questions do
        resources :answers, only: %i[create edit update destroy]
        resources :comments, only: %i[create destroy]
      end
      resources :answers, only: %i[create edit update destroy] do
        resources :comments, only: %i[create destroy]
      end
    end

    namespace :admin do
      resources :users, only: %i[index create]
    end

    resources :questions, only: %i[index show]
  end
end
