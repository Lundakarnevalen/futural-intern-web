Futural::Application.routes.draw do
  resources :notifications, only: [:new, :create, :show, :index]
  resources :karnevalister do 
  	collection do
  		get 'step1'
  		post 'step1_post'
  	end
  	member do
  		get 'step2'
  		get 'step3'
  		get 'step4'
  		post 'enter_pwd'
  		put 'step3_put'
        put 'step4_put'
  	end
  end

  devise_for :users

  root to: 'home#index'
end
