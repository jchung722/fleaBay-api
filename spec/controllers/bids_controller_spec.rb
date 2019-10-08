require 'rails_helper'

RSpec.describe BidsController, type: :controller do
  describe 'POST #create' do
    it 'creates a new bid for the current user and specified auction' do
      allow(controller).to receive(:authorize_access_request!)
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      valid_attributes = {amount: 5}
      bid = Bid.new(valid_attributes)
      allow(controller).to receive(:current_user) { user }

      expect(user).to receive_message_chain(:bids, :build) { bid }
      expect(bid).to receive(:save)
      post :create, params: { bid: valid_attributes, id: 1 }
    end

    it 'renders a JSON response with status of created for a valid bid' do
      allow(controller).to receive(:authorize_access_request!)
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      valid_attributes = {amount: 5}
      bid = Bid.new(valid_attributes)
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:bids, :build) { bid }
      allow(bid).to receive(:save) { true }

      post :create, params: { bid: valid_attributes, id: 1 }
      expect(response).to have_http_status(:created)
    end

    it 'renders a JSON response with errors for invalid bid' do
      allow(controller).to receive(:authorize_access_request!)
      user = double('user')
      bid = double('bid')
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:bids, :build) { bid }
      allow(bid).to receive(:save) { false }

      expect(bid).to receive_message_chain(:errors, :full_messages, :join)
      post :create, params: { bid: { amount: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not allow unauthorized users to create bid' do
      user = double('user')
      bid = double('bid')
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:bids, :build) { bid }

      expect(bid).to receive(:save).never
      post :create, params: { bid: { amount: nil } }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
