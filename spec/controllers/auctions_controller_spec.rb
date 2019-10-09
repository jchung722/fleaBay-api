require 'rails_helper'

RSpec.describe AuctionsController, type: :controller do
  describe 'GET #index' do
    it 'gets all Auctions' do
      expect(Auction).to receive(:all)
      get :index
    end

    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'finds the requested auction' do
      auction = double('my_auction')
      bid = double('bid')
      allow(auction).to receive_message_chain(:user, :email)
      allow(auction).to receive(:highest_bid) { bid }
      allow(bid).to receive_message_chain(:user, :email)

      expect(Auction).to receive(:find).with('1') { auction }
      get :show, params: { id: 1 }

      body = JSON.parse(response.body)
      expect(body['auction']['name']).to eq('my_auction')
    end

    it 'finds the email of requested auction owner' do
      auction = double('auction')
      bid = double('bid')
      allow(Auction).to receive(:find).with('1') { auction }
      allow(auction).to receive(:highest_bid) { bid }
      allow(bid).to receive_message_chain(:user, :email)

      expect(auction).to receive_message_chain(:user, :email) { 'owner@email.com' }
      get :show, params: { id: 1 }

      body = JSON.parse(response.body)
      expect(body['auction_owner']).to eq('owner@email.com')
    end

    it 'finds the highest bid of the requested auction' do
      auction = double('auction')
      bid = double('my_bid')
      allow(Auction).to receive(:find).with('1') { auction }
      allow(auction).to receive_message_chain(:user, :email)
      allow(bid).to receive_message_chain(:user, :email)

      expect(auction).to receive(:highest_bid) { bid }
      get :show, params: { id: 1 }

      body = JSON.parse(response.body)
      expect(body['highest_bid']['name']).to eq('my_bid')
    end

    it 'finds the email of highest bidder of requested auction' do
      auction = double('auction')
      bid = double('my_bid')
      allow(Auction).to receive(:find).with('1') { auction }
      allow(auction).to receive_message_chain(:user, :email)
      allow(auction).to receive(:highest_bid) { bid }

      expect(bid).to receive_message_chain(:user, :email) { 'bidowner@email.com' }
      get :show, params: { id: 1 }

      body = JSON.parse(response.body)
      expect(body['highest_bidder']).to eq('bidowner@email.com')
    end
  end

  describe 'POST #create' do
    it 'creates an auction for the current user' do
      allow(controller).to receive(:authorize_access_request!)
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      valid_attributes = { name: 'name', starting_bid: 1, end_date: Date.today}
      auction = Auction.new(valid_attributes)
      allow(controller).to receive(:current_user) { user }

      expect(user).to receive_message_chain(:auctions, :build) { auction }
      expect(auction).to receive(:save)
      post :create, params: { auction: valid_attributes }
    end

    it 'renders a JSON response with status of created for an auction with valid attributes' do
      allow(controller).to receive(:authorize_access_request!)
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      valid_attributes = { name: 'name', starting_bid: 1, end_date: Date.today, user_id: user }
      auction = Auction.new(valid_attributes)
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:auctions, :build) { auction }
      allow(auction).to receive(:save) { true }

      post :create, params: { auction: valid_attributes }
      expect(response).to have_http_status(:created)
    end

    it 'renders a JSON response with errors for an auction with invalid attributes' do
      allow(controller).to receive(:authorize_access_request!)
      auction = double('auction')
      user = double('user')
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:auctions, :build) { auction }
      allow(auction).to receive(:save) { false }

      expect(auction).to receive_message_chain(:errors, :full_messages, :join)
      post :create, params: { auction: { name: 'name' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not allow unauthorized users to create bid' do
      auction = double('auction')
      user = double('user')
      allow(user).to receive_message_chain(:auctions, :build) { auction }

      expect(auction).to receive(:save).never
      post :create
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'PUT #update' do
    it 'updates the requested auction for the current user' do
      allow(controller).to receive(:authorize_access_request!)
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      auction = Auction.new(name: 'name', starting_bid: 1, end_date: Date.today, user_id: user)
      allow(controller).to receive(:current_user) { user }

      expect(user).to receive_message_chain(:auctions, :find).with('1') { auction }
      expect(auction).to receive(:update)
      put :update, params: { id: 1, auction: { name: 'new_name' } }
    end

    it 'renders a JSON response with OK status for valid auction update' do
      allow(controller).to receive(:authorize_access_request!)
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      auction = Auction.new(name: 'name', starting_bid: 1, end_date: Date.today, user_id: user)
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:auctions, :find) { auction }
      allow(auction).to receive(:update) { true }

      put :update, params: { id: 1, auction: { name: 'new_name' } }
      expect(response).to have_http_status(:ok)
    end

    it 'renders a JSON response with errors for invalid auction update' do
      allow(controller).to receive(:authorize_access_request!)
      user = double('user')
      auction = double('auction')
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:auctions, :find) { auction }
      allow(auction).to receive(:update) { false }

      expect(auction).to receive_message_chain(:errors, :full_messages, :join)
      put :update, params: { id: 1, auction: { name: 'new_name' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not allow unauthorized users to create bid' do
      user = double('user')
      auction = double('auction')
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:auctions, :find) { auction }

      expect(auction).to receive(:update).never
      put :update, params: { id: 1, auction: { name: 'new_name' } }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys requested auction of current user' do
      allow(controller).to receive(:authorize_access_request!)
      user = double('user')
      auction = double('auction')
      allow(controller).to receive(:current_user) { user }

      expect(user).to receive_message_chain(:auctions, :find).with('1') { auction }
      expect(auction).to receive(:destroy)
      delete :destroy, params: { id: 1 }
    end

    it 'does not allow unauthorized users to delete bid' do
      user = double('user')
      auction = double('auction')
      allow(controller).to receive(:current_user) { user }
      allow(user).to receive_message_chain(:auctions, :find).with('1') { auction }

      expect(auction).to receive(:update).never
      delete :destroy, params: { id: 1 }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
