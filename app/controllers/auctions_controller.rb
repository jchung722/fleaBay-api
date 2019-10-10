class AuctionsController < ApplicationController
  before_action :authorize_access_request!, except: [:show, :index]
  before_action :set_auction, only: [:update, :destroy]

  def index
    @auctions = Auction.all

    render json: @auctions, include: :highest_bid
  end

  def show
    @auction = Auction.find(params[:id])
    auction_owner = @auction.user.email
    highest_bid = @auction.highest_bid
    highest_bidder = highest_bid&.user&.email
    render json: { auction: @auction,
                   auction_owner: auction_owner,
                   highest_bid: highest_bid,
                   highest_bidder: highest_bidder }
  end

  def create
    @auction = current_user.auctions.build(auction_params)

    if @auction.save
      render json: @auction, status: :created, location: @auction
    else
      render json: { error: @auction.errors.full_messages.join('; ') }, status: :unprocessable_entity
    end
  end

  def update
    if @auction.update(auction_params)
      render json: @auction
    else
      render json: { error: @auction.errors.full_messages.join('; ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @auction.destroy
  end

  private

  def set_auction
    @auction = current_user.auctions.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(:name, :description, :picture, :starting_bid, :end_date, :user_id)
  end
end
