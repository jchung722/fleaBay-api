class Auction < ApplicationRecord
  belongs_to :user
  has_many :bids
  validates :name, presence: true
  validates :starting_bid, presence: true, numericality: { greater_than: 0 }
  validates :end_date, presence: true
  validate :end_date_must_be_future

  def end_date_must_be_future
    errors.add(:end_date, 'must be later than today') unless end_date && end_date > Date.today
  end

  def highest_bid
    self&.bids&.order(amount: :desc)&.first
  end

  def highest_bid_amount
    highest_bid ? highest_bid.amount : starting_bid
  end
end
