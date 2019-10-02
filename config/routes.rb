Rails.application.routes.draw do
  get '/', to: 'home#index'
  post '/signup', to: 'signup#create'
end
