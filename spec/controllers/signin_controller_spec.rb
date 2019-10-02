require 'rails_helper'

RSpec.describe SigninController, type: :controller do
  describe 'POST #create' do
    it 'authenticates specified user' do
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      allow(User).to receive(:find_by) { user }

      expect(user).to receive(:authenticate)
      post :create
    end

    it 'creates a session for authenticated user' do
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      allow(User).to receive(:find_by) { user }
      allow(user).to receive(:authenticate) { true }

      expect(JwtSessionWrapper).to receive(:create_session)
      post :create
    end

    it 'sends a json error message for unauthorized user' do
      user = User.new
      allow(User).to receive(:find_by) { user }
      allow(user).to receive(:authenticate) { false }

      post :create

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(body['error']).to eq('Not authorized')
    end
  end

  describe 'DELETE #destroy' do
    it 'ends session for authenticated user' do
      allow(controller).to receive(:authorize_access_request!)

      expect(JwtSessionWrapper).to receive(:end_session)
      delete :destroy
    end
  end
end
