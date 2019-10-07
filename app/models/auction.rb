class Auction < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  validates :name, presence: true
  validates :bid, presence: true
  validates :end_date, presence: true
end
