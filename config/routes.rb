Cybersourcery::Application.routes.draw do
  resources :profiles
  root to: 'profiles#index'
end
