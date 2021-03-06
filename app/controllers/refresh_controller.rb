class RefreshController < ApplicationController
  before_action :authorize_refresh_by_access_request!

  def create
    JwtSessionWrapper.refresh_session(response, claimless_payload)
  end
end
