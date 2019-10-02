require 'rails_helper'

RSpec.describe SignupController, type: :controller do
  describe 'POST #create' do
    it 'creates a user' do
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      allow(User).to receive(:new) { user }

      expect(user).to receive(:save)
      post :create
    end

    it 'creates a session if a valid user is created' do
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      allow(User).to receive(:new) { user }

      expect(JwtSessionWrapper).to receive(:create_session)
      post :create
    end

    it 'sends a json error message for invalid user parameters' do
      user = User.new
      allow(User).to receive(:new) { user }

      post :create

      body = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(body['error']).to eq("Email can't be blank Email is invalid Password can't be blank")
    end
  end
end
