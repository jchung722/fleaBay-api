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
      expect(Auction).to receive(:find).with('1')
      get :show, params: { id: 1 }
    end
  end

  describe 'POST #create' do
    it 'creates an auction' do
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      valid_attributes = { name: 'name', description: nil, picture: nil, bid: 1, end_date: Date.today, user_id: user }
      allow(controller).to receive(:authorize_access_request!)
      auction = Auction.new(valid_attributes)
      allow(Auction).to receive(:new) { auction }
      allow(auction).to receive(:save) { true }

      expect(auction).to receive(:save)
      post :create, params: { auction: valid_attributes }
    end

    it 'renders a JSON response with status of created for an auction with valid attributes' do
      user = User.new(email: 'tester@gmail.com', password: 'badpassword')
      valid_attributes = { name: 'name', description: nil, picture: nil, bid: 1, end_date: Date.today, user_id: user }
      allow(controller).to receive(:authorize_access_request!)
      auction = Auction.new(valid_attributes)
      allow(Auction).to receive(:new) { auction }
      allow(auction).to receive(:save) { true }

      post :create, params: { auction: valid_attributes }
      expect(response).to have_http_status(:created)
    end

    it 'renders a JSON response with errors for an auction with invalid attributes' do
      allow(controller).to receive(:authorize_access_request!)
      auction = double('auction')
      allow(Auction).to receive(:new) { auction }
      allow(auction).to receive(:save) { false }

      expect(auction).to receive(:errors)
      post :create, params: { auction: { name: 'name' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #update' do
    it 'updates the requested auction' do
      allow(controller).to receive(:authorize_access_request!)
      auction = double('auction')
      allow(auction).to receive(:update) { true }

      expect(Auction).to receive(:find).with('1') { auction }
      expect(auction).to receive(:update)
      put :update, params: {id: 1, auction: { name: 'new_name' } }
    end

    it 'renders a JSON response with OK status for valid auction update' do
      allow(controller).to receive(:authorize_access_request!)
      auction = double('auction')
      allow(auction).to receive(:update) { true }
      expect(Auction).to receive(:find).with('1') { auction }

      put :update, params: {id: 1, auction: { name: 'new_name' } }
      expect(response).to have_http_status(:ok)
    end

    it 'renders a JSON response with errors for invalid auction update' do
      allow(controller).to receive(:authorize_access_request!)
      auction = double('auction')
      allow(auction).to receive(:update) { false }
      expect(Auction).to receive(:find).with('1') { auction }

      expect(auction).to receive(:errors)
      put :update, params: {id: 1, auction: { name: 'new_name' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested auction' do
      allow(controller).to receive(:authorize_access_request!)
      auction = double('auction')

      expect(Auction).to receive(:find).with('1') { auction }
      expect(auction).to receive(:destroy)
      delete :destroy, params: { id: 1 }
    end
  end
end
