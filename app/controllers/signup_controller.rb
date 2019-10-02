class SignupController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      JwtSessionWrapper.create_session(user)
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
