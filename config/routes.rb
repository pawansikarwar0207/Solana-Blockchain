Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  post "/users/update_wallet", to: "users#update_wallet"

  get "/my_orders/orders", to: 'orders#my_orders', as: :my_orders_orders

  resources :orders do
    member do
      get :upload_providers
      post :submit_providers
      get :checkout
      get :payment_success
      get :cancel_order
      get :pay
      post :confirm_payment
      get :confirm_crypto_payment
      get :status                
    end

    collection do
      get :new
      post :create
    end
  end

  resources :verification_products

  namespace :admin do
    resources :orders, only: [:index, :show]
    resources :verification_products, only: [:new, :create]
    resources :transaction_logs

    resources :provider_profiles, only: [] do
      member do
        post :mark_verified
        post :mark_failed
      end
    end
  end
end
