require 'rails_helper'

RSpec.describe RefreshController, type: :controller do
  it 'refreshes session' do
    allow(controller).to receive(:authorize_refresh_by_access_request!)
    allow(controller).to receive(:claimless_payload)
    
    expect(JwtSessionWrapper).to receive(:refresh_session)
    post :create
  end
end
