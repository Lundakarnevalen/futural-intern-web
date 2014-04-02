Futural::Application.routes.draw do
  root :to => 'home#index'

  resources :phones, only: [:new, :create]
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
  # /warehouse/..
  namespace :warehouse do
    get '/dashboard', to: 'dashboard#home'
    resources :orders do
      collection do
        get 'calendar'
        get 'list'
        get 'search/:search_param', :action => 'search'
        get 'search', :action => 'search'
      end
    end

    resources :products do
      collection do
        get 'incoming_deliveries'
        get 'weekly_overview'
        put 'update_multiple'
        get 'inactivate'
        get 'activate'
      end
    end

    resources :product_categories
    resources :order_products
  end

  get '/home', to: 'home#index'

  devise_for :users
end
