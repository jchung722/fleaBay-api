class AuctionsController < ApplicationController
  before_action :authorize_access_request!, except: [:show, :index]
  before_action :set_auction, only: [:update, :destroy]

  def index
    @auctions = Auction.all
    render json: @auctions
  end

  def show
    @auction = Auction.find(params[:id])
    render json: @auction
  end

  def create
    @auction = current_user.auctions.build(auction_params)

    if @auction.save
      @auction.image.attach
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
    @auction = current_user.auctions.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(:name, :description, :picture, :bid, :end_date, :user_id)
  end
end
