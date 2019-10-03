Rails.application.routes.draw do
  resources :auctions
  root to: 'home#index'
  post '/refresh', to: 'refresh#create'
  post '/signup', to: 'signup#create'
  post '/signin', to: 'signin#create'
  delete '/signin', to: 'signin#destroy'
end
