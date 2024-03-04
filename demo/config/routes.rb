Rails.application.routes.draw do
  mount Lookbook::Engine, at: "/lookbook"

  resources :products
  resources :suggestions, only: :index
  resource :uploads, only: :create

  get "up" => "rails/health#show", as: :rails_health_check

  root to: redirect("/lookbook")
end
