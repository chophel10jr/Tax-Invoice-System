Rails.application.routes.draw do
  root to: 'home#show'

  # Sessions (login/logout)
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :invoices, only: [:create, :edit, :update, :show]
  resources :transactions, only: [:edit, :update]
  resources :customers, only: [:edit, :update]
end
