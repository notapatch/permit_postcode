Rails.application.routes.draw do
  root to: "home#index"
  resources :postcode_checks, only: [:new, :create]
end
