Rails.application.routes.draw do
  get '/', to: 'home#index'
  post '/refresh', to: 'refresh#create'
  post '/signup', to: 'signup#create'
  post '/signin', to: 'signin#create'
  delete '/signin', to: 'signin#destroy'
end
