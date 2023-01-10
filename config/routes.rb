# frozen_string_literal: true

require 'sidekiq/web'

class AdminConstraint
  def matches?(request)
    user_id = request.session[:user_id] || request.cookie_jar.encrypted[:user_id]

    User.find_by(id: user_id)&.admin_role?
  end
end

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  namespace :api do
    resources :tags, only: :index
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    resource :session, only: %i[new create destroy]

    resource :password_reset, only: %i[new create edit update]

    root to: 'pages#index'
    resources :users, only: %i[new create edit update]

    shallow do
      resources :questions, concerns: :commentable do
        resources :answers, only: %i[create edit update destroy]
      end
      resources :answers, concerns: :commentable
    end

    namespace :admin do
      resources :users, only: %i[index create edit update destroy]
    end

    resources :questions, only: %i[index show]
  end
end
