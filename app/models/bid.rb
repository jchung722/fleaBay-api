class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :auction
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :amount_must_be_highest_bid
  validate :auction_cannot_be_over
  validate :bidder_cannot_be_auction_owner

  def amount_must_be_highest_bid
    errors.add(:amount, 'must be higher than highest bid') unless auction && amount > auction.highest_bid_amount
  end

  def auction_cannot_be_over
    errors.add(:auction, "can't be past end date") unless auction && auction.end_date > Date.today
  end

  def bidder_cannot_be_auction_owner
    errors.add(:user, "bidder can't be auction owner") unless user_id && user_id != auction.user_id
  end
end
