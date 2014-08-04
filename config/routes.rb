Cybersourcery::Application.routes.draw do
  resources :payments, only: [:new, :create]
  resources :responses, only: :show
  resources :profiles
  root to: 'payments#new'
end
