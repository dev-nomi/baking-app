Rails.application.routes.draw do
  # Semi-static page routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/search', to: 'home#search', as: :search

  # Authentication routes
  
  resources :users, except: [:show, :destroy]

  get '/cart', to: 'cart#show', as: :view_cart
  get '/cart/checkout', to: 'cart#checkout', as: :checkout
  get '/cart', to: 'cart#index', as: :index_cart
  get '/cart/new', to: 'cart#new', as: :add_item
  patch '/cart/:id/edit', to: 'cart#update', as: :edit_cart
  get '/cart/empty', to: 'cart#empty', as: :empty_cart
  #post '/cart', to: 'cart#create', as: :checkout
  get '/cart/:id', to: 'cart#destroy', as: :remove_item
 

  resources :customers
  resources :addresses
  resources :orders             
  resources :categories, except: [:show, :destroy]
  
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  resources :sessions, except: [:new, :destroy]
  
  resources :items
  patch '/items/toggle_active/:id', to: 'items#toggle_active', as: :toggle_active
  patch '/items/toggle_feature/:id', to: 'items#toggle_feature', as: :toggle_feature
  resources :item_prices, except: [:index, :show, :edit, :update, :destroy]
  

  root 'home#index'
 # API routing
 scope module: 'api', defaults: {format: 'json'} do
  namespace :v1 do
    # Only need two routes for the API
    get 'orders', to: 'orders#index'
    get 'customers/:id', to: 'customers#show'
  end
end

end