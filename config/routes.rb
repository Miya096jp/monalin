Rails.application.routes.draw do
  get "welcome/index"
  get "up" => "rails/health#show", as: :rails_health_check
  root "welcome#index"

  resource :auth_session, only: [ :create, :destroy ], path: "login"
  resource :registration, only: [ :new, :create ], path: "signup"
  get "/auth/:provider/callback", to: "auth_sessions#create"
  get "/auth/failure", to: "auth_sessions#failure"
  get "login", to: "auth_sessions#new", as: :login
  get "signup", to: "registrations#new", as: :signup

  get "home", to: "pages#home", as: :home
  resources :sessions, except: [ :index ] do
    resources :messages, only: [ :create, :update ]
  end
end
