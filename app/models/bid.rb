class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction
  validates :amount, presence: true
  validate :amount_must_be_highest_bid
  validate :auction_cannot_be_over

  def amount_must_be_highest_bid
    errors.add(:amount, "can't be lower than highest bid") unless auction && amount > auction.highest_bid_amount
  end

  def auction_cannot_be_over
    errors.add(:auction, "can't be over") unless auction && auction.end_date > Date.today
  end
end
