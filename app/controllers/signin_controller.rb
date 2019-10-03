class SigninController < ApplicationController
  before_action :authorize_access_request!, only: [:destroy]
  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      tokens = JwtSessionWrapper.create_session(user, response)
      render json: { csrf: tokens[:csrf] }
    else
      not_authorized
    end
  end

  def destroy
    JwtSessionWrapper.end_session(payload)
    render json: :ok
  end
end
