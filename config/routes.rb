Rails.application.routes.draw do
  root to: 'home#index'
  resources :auctions
  resource :bids, only: [:create], path: '/' do
    get :create, on: :member, path: '/auctions/:id/bids'
  end
  post '/auctions/:id/bids/', to: 'bids#create'
  post '/refresh', to: 'refresh#create'
  post '/signup', to: 'signup#create'
  post '/signin', to: 'signin#create'
  delete '/signin', to: 'signin#destroy'
end
