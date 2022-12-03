Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do  
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
    get 'sign_out', to: 'devise/sessions#destroy'
  end
  
  get 'pages/index'
  root to: "pages#index"
  
  shallow do
    resources :users do 
      resources :questions
    end
    resources :questions do 
      resources :answers, only: %i[create edit update destroy]
    end
  end

  resources :questions, only: [:index, :show]
end
