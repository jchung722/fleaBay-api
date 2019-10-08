require 'rails_helper'

RSpec.describe RefreshController, type: :controller do
  describe 'POST #create' do
    it 'refreshes session' do
      allow(controller).to receive(:authorize_refresh_by_access_request!)
      allow(controller).to receive(:claimless_payload)

      expect(JwtSessionWrapper).to receive(:refresh_session)
      post :create
    end

    it 'can not refresh session for unauthorized user' do
      expect(JwtSessionWrapper).to receive(:refresh_session).never
      post :create
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
