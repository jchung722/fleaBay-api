class Auction < ApplicationRecord
  belongs_to :user
  has_many :bids
  validates :name, presence: true
  validates :starting_bid, presence: true
  validates :end_date, presence: true

  def highest_bid
    self&.bids&.order(amount: :desc)&.first
  end

  def highest_bid_amount
    highest_bid ? highest_bid.amount : starting_bid
  end
end
