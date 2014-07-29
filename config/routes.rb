Cybersourcery::Application.routes.draw do
  resources :payments, only: :new
  resources :profiles
  root to: 'profiles#index'
end
