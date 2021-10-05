Rails.application.routes.draw do
  mount Lookbook::Engine, at: "/lookbook"

  resources :products

  get 'test', to: "test#hello"

  root to: redirect('/lookbook')
end
