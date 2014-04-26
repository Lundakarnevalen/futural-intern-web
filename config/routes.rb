# -*- encoding : utf-8 -*-
  Futural::Application.routes.draw do
  resources :tests

  root :to => 'home#index'

  devise_for :users

  resources :phones, only: [:new, :create]
  resources :posts, only: [:new, :create, :edit, :update, :destroy, :show]

  namespace :api do
    devise_for :users
    get '/tests', to: 'test#index'
    resources :clusters, only: [:create, :update, :index]
    resources :karnevalister, only: [:update]
    resources :notifications, only: [:index]
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
      get 'export_all', :action => 'export_all'
      get 'check', :action => :check
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
      # Access
      get 'roles', :to => 'roles#roles'
      post 'roles/:role_id', :to => 'roles#grant'
      delete 'roles/:role_id', :to => 'roles#revoke'
    end
  end

  resources :sektioner do
    member do
      get 'export', :to => 'sektioner#export'
      get 'kollamedlem', :to => 'sektioner#kollamedlem'
      get 'aktiva', :to => 'sektioner#aktiva'
      get 'edit', :to => 'sektioner#edit_info'
      get 'contact', :to => 'sektioner#show_contact'
      get 'contact/edit', :to => 'sektioner#edit_contact'
      get 'english', :to => 'sektioner#show_english'
      get 'english/edit', :to => 'sektioner#edit_english'
    end
  end

  resources :bookkeepings

  resources :events do
    member do
      get 'attending'
      get 'sign_up'
      put 'attend'
    end
  end

  resources :roles, :only => [:index]

=begin
  # concern for festmästeriet / fabriken
  concern :party_factory do
    resources :orders, controller: 'warehouse/products' do
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
=end
  concern :party_factory do
    resources :orders do
      collection do
        get 'calendar', to: 'orders#calendar'
        get 'list', to: 'orders#list'
        get 'sektion', to: 'orders#sektion'
        get 'search/:search_param', to: 'orders#search'
        get 'search', to: 'orders#search'
        get 'direct_selling', to: 'orders#direct_selling'
        post 'direct_selling_post', to: 'orders#direct_selling_post'
        get 'update_customers', to: 'orders#update_customers'
      end
      member do
        put 'return_products', to: 'orders#return_products'
        get 'confirm', to: 'orders#confirm'
        put 'confirm_put', to: 'orders#confirm_put'
      end
    end

    resources :products do
      collection do
        get 'weekly_overview', to: 'products#weekly_overview'
      end
      member do
        get 'inactivate', to: 'products#inactivate'
        get 'activate', to: 'products#activate'
      end
    end

    resources :incoming_deliveries
    resources :product_categories
    resources :order_products
    resources :partial_deliveries
  end

  namespace :warehouse, path: 'fabriken', as: 'fabriken' do
    concerns :party_factory
    resources :reservations
  end

  namespace :warehouse, path: 'festmasteriet', as: 'fest' do
    concerns :party_factory
  end
  
  namespace :warehouse, path: 'snaxeriet', as: 'snaxeriet' do
    concerns :party_factory
  end

  get '/home', to: 'home#index'
  get '/internapp', to: 'home#app_store'
  get '/markdown', to: 'home#markdown'
end
