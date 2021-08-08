Rails.application.routes.draw do
  mount Lookbook::Engine, at: "/lookbook"

  resources :products

  root to: redirect('/lookbook')
end
