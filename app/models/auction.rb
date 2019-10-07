class Auction < ApplicationRecord
  belongs_to :user
  has_many :bids
  validates :name, presence: true
  validates :starting_bid, presence: true
  validates :end_date, presence: true
end
