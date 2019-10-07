class Auction < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :starting_bid, presence: true
  validates :end_date, presence: true
end
