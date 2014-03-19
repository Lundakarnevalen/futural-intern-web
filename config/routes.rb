  Futural::Application.routes.draw do
  root :to => 'home#index'
=begin
  scope format: true, constraints: { format: 'json'} do
    post '/phones', to: 'api/phones#create'
  end
=end

  devise_for :users
  scope constraints: { :format => 'json' } do
    resources :phones, controller: "api/phones", only: [:new, :create] #'/phones' => 'api/phones#create'
  end
  #post 'phones' => 'phones#create'

  scope constrains: { format: 'html' } do
    resources :phones, only: [:new, :create]
  end

  namespace :api do
    devise_for :users
    constraints format: :json do
      resources :phones, only: [:new, :create]
    end
  end



  resources :notifications, only: [:new, :create, :show, :index]

  resources :karnevalister do
    collection do
      get 'search/:q', :action => 'search'
      get 'search', :action => 'search'
      get 'step1'
      post 'step1_post'
      get 'checkout'
      get 'checkout_paper'
      post 'checkout_paper_post'
      get 'uppdelning'
      post 'gealla'
      get 'search_filter', :action => 'search_filter'
      get 'pusseldagen'
      get 'search_filter_pusseldag', :action => 'search_filter_pusseldag'
    end

    member do
      get 'step2'
      get 'step3'
      get 'step4'
      get 'checkout_digital'
      get 'show_modal'
      post 'enter_pwd'
      put 'step3_put'
      put 'checkout_digital_put'
    end
  end

  resources :sektioner do
    collection do
      get ':id/export', :to => 'sektioner#export'
      get ':id/kollamedlem', :to => 'sektioner#kollamedlem'
    end
  end

  get '/home', to: 'home#index'

end
