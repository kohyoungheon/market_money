Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v0 do
      delete '/market_vendors/', to: 'market_vendors#destroy'
      get 'markets/search', to: 'markets#search'
      get 'markets/:id/nearest_atms', to: 'markets#nearest_atms'
      
      resources :market_vendors, only: [:create]
      resources :vendors, only: [:show, :create, :update, :destroy]

      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index]
      end
    end
  end

end
