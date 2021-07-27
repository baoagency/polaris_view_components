Rails.application.routes.draw do
  mount Lookbook::Engine, at: "/lookbook"

  root to: redirect('/lookbook')
end
