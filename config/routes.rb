Futural::Application.routes.draw do
  resources :notifications, only: [:new, :create, :show, :index]
  resources :karnevalister

  devise_for :users

  root to: 'home#index'
end
