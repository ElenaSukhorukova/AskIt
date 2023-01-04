# frozen_string_literal: true

Rails.application.routes.draw do
  concern :commentable do 
    resources :comments, only: %i[create destroy]
  end

  namespace :api do
    resources :tags, only: :index
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    resource :session, only: %i[new create destroy]

    root to: 'pages#index'
    resources :users, only: %i[new create edit update]

    shallow do
      resources :questions, concerns: :commentable do
        resources :answers, only: %i[create edit update destroy] 
      end
      resources :answers, concerns: :commentable
    end

    namespace :admin do
      resources :users, only: %i[index create]
    end

    resources :questions, only: %i[index show]
  end
end
