Rails.application.routes.draw do
  root to: 'invoices#index'

  # Sessions (login/logout)
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :invoices, only: [:create, :show, :index, :new] do
    member do
      get :generate_pdf
    end
  end

  resources :transactions, only: [:edit, :update]
  resources :customers, only: [:edit, :update]
end
