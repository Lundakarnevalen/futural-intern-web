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

  # concern for festmästeriet / fabriken
  concern :party_factory do
    resources :orders, controller: 'warehouse/orders' do
      collection do
        get 'calendar', to: 'warehouse/orders#calendar'
        get 'list', to: 'warehouse/orders#list'
        get 'search/:search_param', to: 'warehouse/orders#search'
        get 'search', to:'warehouse/orders#search'
      end
      member do
        put 'return_products', to: 'warehouse/orders#return_products'
        get 'confirm', to: 'warehouse/orders#confirm'
        put 'confirm_put', to: 'warehouse/orders#confirm_put'
      end
    end

    resources :products, controller: 'warehouse/products' do
      collection do
        get 'weekly_overview', to: 'warehouse/products#weekly_overview'
      end
      member do
        get 'inactivate', to: 'warehouse/products#inactivate'
        get 'activate', to: 'warehouse/products#activate'
      end
    end

    resources :incoming_deliveries, controller: 'warehouse/incoming_deliveries'
    resources :product_categories, controller: 'warehouse/product_categories'
    resources :order_products, controller: 'warehouse/order_products'
  end

  scope '/fabriken' do
    concerns :party_factory
  end

  scope '/festmasteriet' do
    concerns :party_factory
  end
  get '/home', to: 'home#index'

  devise_for :users
end
