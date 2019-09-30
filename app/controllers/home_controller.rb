class HomeController < ApplicationController
  def index
    render json: { greeting: 'Welcome to fleaBay!' }
  end
end
