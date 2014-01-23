Futural::Application.routes.draw do
  resources :karnevalister

  devise_for :users

  root to: 'home#index'
end
