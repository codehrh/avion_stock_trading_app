Rails.application.routes.draw do
  get "portfolios/show"
  devise_for :users, defaults: { format: :html }

  root "home#index"

  namespace :admin do
    resources :users do
      member do
        patch :approve
        delete :deny
      end
    end
    resources :transactions
  end

  resources :transactions


  resources :stocks, only: [:create] do
    collection do
      get :intraday
      put :update_stock, to: "stocks#update"
    end
  end

  get "stocks/intraday", to: "stocks#intraday", as: "stocks_intraday"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  default_url_options :host => "gmail.com"

  # Defines the root path route ("/")
end
