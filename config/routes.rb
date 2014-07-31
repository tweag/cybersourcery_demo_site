Cybersourcery::Application.routes.draw do
  resources :payments, only: [:new, :create]
  resources :profiles
  root to: 'payments#new'
end
