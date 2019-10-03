class AuctionsController < ApplicationController
  before_action :authorize_access_request!, except: [:show, :index]
  before_action :set_auction, only: [:show, :update, :destroy]

  def index
    @auctions = Auction.all

    render json: @auctions
  end

  def show
    render json: @auction
  end

  def create
    @auction = Auction.new(auction_params)

    if @auction.save
      render json: @auction, status: :created, location: @auction
    else
      render json: @auction.errors, status: :unprocessable_entity
    end
  end

  def update
    if @auction.update(auction_params)
      render json: @auction
    else
      render json: @auction.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @auction.destroy
  end

  private

  def set_auction
    @auction = Auction.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(:name, :description, :picture, :bid, :end_date, :user_id)
  end
end
