require 'rails_helper'

RSpec.describe Auction, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:bids) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:starting_bid) }
    it { should validate_presence_of(:end_date) }
    it { should validate_numericality_of(:starting_bid).is_greater_than(0) }

    it 'validates an end_date later than today' do
      user = User.new(id: 1, email: 'test@gmail.com', password: 'pw')
      auction = Auction.new(name: 'cool thing', starting_bid: '2', end_date: Date.tomorrow, user: user)

      expect(auction).to be_valid
    end

    it 'invalidates an end_date today' do
      user = User.new(id: 1, email: 'test@gmail.com', password: 'pw')
      auction = Auction.new(name: 'cool thing', starting_bid: '2', end_date: Date.today, user: user)

      expect(auction).not_to be_valid
    end

    it 'invalidates an end_date earlier than today' do
      user = User.new(id: 1, email: 'test@gmail.com', password: 'pw')
      auction = Auction.new(name: 'cool thing', starting_bid: '2', end_date: Date.yesterday, user: user)
      
      expect(auction).not_to be_valid
    end
  end

  describe '#highest_bid' do
    it 'will return nil if no bids were made' do
      auction = Auction.new(name: 'cool thing', starting_bid: 2, end_date: Date.today)

      expect(auction.highest_bid).to be_nil
    end

    it 'will return highest bid if competing bids are made' do
      user = User.create(email: 'test@gmail.com', password: 'pw')
      bidder = User.create(email: 'test2@gmail.com', password: 'pw')
      auction = Auction.create(name: 'cool thing', starting_bid: 2, end_date: Date.tomorrow, user: user)
      lower_bid = auction.bids.create(amount: 3, user: bidder)
      higher_bid = auction.bids.create(amount: 5, user: bidder)

      expect(auction.highest_bid).to eq(higher_bid)
    end
  end

  describe '#highest_bid_amount' do
    it 'will return highest bid amount as starting bid if no bids are made' do
      auction = Auction.new(name: 'cool thing', starting_bid: 2, end_date: Date.today)

      expect(auction.highest_bid_amount).to eq(2)
    end

    it 'will return highest bid amount when competing bids are made' do
      user = User.create(email: 'test@gmail.com', password: 'pw')
      bidder = User.create(email: 'test2@gmail.com', password: 'pw')
      auction = Auction.create(name: 'cool thing', starting_bid: 2, end_date: Date.tomorrow, user: user)
      auction.bids.create(amount: 3, user: bidder)
      auction.bids.create(amount: 5, user: bidder)

      expect(auction.highest_bid_amount).to eq(5)
    end
  end
end
