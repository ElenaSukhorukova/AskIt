Rails.application.routes.draw do
  resource :session, only: %i[new create destroy]
  resources :users, only: %i[new create new update]


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
