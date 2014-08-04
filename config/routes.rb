Cybersourcery::Application.routes.draw do
  resources :payments, only: [:new, :create]
  resources :responses, only: :index
  resources :profiles
  root to: 'payments#new'
end
