class BidsController < ApplicationController
  before_action :authorize_access_request!

  def create
    @bid = current_user.bids.build(amount: params[:bid][:amount], auction_id: params[:id])

    if @bid.save
      render json: @bid, status: :created, location: @bid
    else
      render json: @bid.errors.full_messages.join(' '), status: :unprocessable_entity
    end
  end
end
