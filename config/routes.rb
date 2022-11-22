Rails.application.routes.draw do
  devise_for :users
  get 'pages/index'
  root to: "pages#index"
  
  shallow do
    resources :users do 
      resources :questions
    end
  end

  resources :questions

end
