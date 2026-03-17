Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "pages#lp"

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"

  resource :session, only: [ :new, :create, :destroy ], path: "login"
  resource :registration, only: [ :new, :create ], path: "signup"

  get "login", to: "sessions#new", as: :login
  get "signup", to: "registrations#new", as: :signup
end
