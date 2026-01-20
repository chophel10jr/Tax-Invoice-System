Rails.application.routes.draw do
  root to: 'invoices#index'

  # Sessions (login/logout)
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :invoices, only: [:create, :edit, :update, :show, :index, :new]
  resources :transactions, only: [:edit, :update]
  resources :customers, only: [:edit, :update]
end
