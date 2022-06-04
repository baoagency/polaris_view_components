Rails.application.routes.draw do
  mount Lookbook::Engine, at: "/lookbook"

  resources :products
  resources :suggestions, only: :index
  resource :uploads, only: :create

  get 'test', to: "test#hello"

  root to: redirect('/lookbook')
end
