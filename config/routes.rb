Rails.application.routes.draw do
  resources :auctions

  resources :bids, only: [:create], path: '/auctions/:id/bids'

  post '/refresh', to: 'refresh#create'

  post '/signup', to: 'signup#create'

  post '/signin', to: 'signin#create'

  delete '/signin', to: 'signin#destroy'
end
