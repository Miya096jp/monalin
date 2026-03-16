Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "pages#lp"

  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
end
