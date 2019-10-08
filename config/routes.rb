Rails.application.routes.draw do
  resources :auctions

  resource :bids, only: [:create], path: '/auctions/:id/bids'

  post '/auctions/:id/bids/', to: 'bids#create'

  post '/refresh', to: 'refresh#create'

  post '/signup', to: 'signup#create'

  post '/signin', to: 'signin#create'

  delete '/signin', to: 'signin#destroy'
end
