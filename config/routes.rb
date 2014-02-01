Futural::Application.routes.draw do
  resources :phones, only: [:new, :create]
  resources :notifications, only: [:new, :create, :show, :index]
  resources :karnevalister do 
  	collection do
  		get 'step1'
  		post 'step1_post'
        get 'checkout'
        get 'checkout_paper'
        post 'checkout_paper_post'
  	end
  	member do
  		get 'step2'
  		get 'step3'
  		get 'step4'
        get 'checkout_digital'
  		post 'enter_pwd'
  		put 'step3_put'
        put 'checkout_digital_put'
  	end
  end

  devise_for :users

  root to: 'home#index'
end
