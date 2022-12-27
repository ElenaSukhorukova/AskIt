# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]

  root to: 'pages#index'

  shallow do
    resources :users, only: %i[new create edit update] do
      resources :questions
    end
    resources :questions do
      resources :answers, only: %i[create edit update destroy]
    end
  end

  namespace :admin do
    resources :users, only: %i[index create]
  end

  resources :questions, only: %i[index show]
end
