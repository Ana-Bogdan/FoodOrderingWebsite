Rails.application.routes.draw do
  # Authentication routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  get "logout", to: "sessions#destroy"
  get "signup", to: "registrations#new"
  post "signup", to: "registrations#create"

  # Cart routes
  get "cart", to: "cart#show"
  post "cart", to: "cart#create", as: :add_to_cart
  delete "cart/:id", to: "cart#destroy", as: :remove_from_cart
  patch "cart/:id", to: "cart#update", as: :update_cart_item
  post "cart/place_order", to: "cart#place_order", as: :place_order

  # Orders routes (admin only)
  resources :orders, only: [ :index ]
  patch "orders/:id/toggle_status", to: "orders#toggle_status", as: :toggle_order_status

  root "products#index"
  resources :products
  get "dashboard", to: "products#dashboard"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :rails_pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :rails_pwa_service_worker

  # Defines the root path ("/")
  # root "posts#index"
end
