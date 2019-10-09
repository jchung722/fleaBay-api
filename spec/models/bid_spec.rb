require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:auction) }
  end

  describe 'validations' do
    let(:user) { User.new(id: 1, email: 'test@gmail.com', password: 'pw') }
    let(:auction) { Auction.new(name: 'cool thing', starting_bid: '2', end_date: Date.tomorrow, user_id: 2) }

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0)}

    it 'validates a bid amount that is higher than current highest auction bid' do
      over_bid = Bid.new(amount: 3, user: user, auction: auction)
      expect(over_bid).to be_valid
    end

    it 'invalidates a bid amount that is equal to current highest auction bid' do
      same_bid = Bid.new(amount: 2, user: user, auction: auction)
      expect(same_bid).not_to be_valid
    end

    it 'invalidates a bid amount that is lower than current highest auction bid' do
      under_bid = Bid.new(amount: 1, user: user, auction: auction)
      expect(under_bid).not_to be_valid
    end

    it 'validates a bid created before auction end date' do
      test_bid = Bid.new(amount: 3, user: user, auction: auction)
      expect(test_bid).to be_valid
    end

    it 'invalidates a bid created on auction end date' do
      auction_today = Auction.new(name: 'cool thing', starting_bid: '2', end_date: Date.today)
      test_bid = Bid.new(amount: 3, user: user, auction: auction_today)
      expect(test_bid).not_to be_valid
    end

    it 'invalidates a bid created after auction end date' do
      auction_yesterday = Auction.new(name: 'cool thing', starting_bid: '2', end_date: Date.yesterday)
      test_bid = Bid.new(amount: 3, user: user, auction: auction_yesterday)
      expect(test_bid).not_to be_valid
    end

    it 'validates a bid created by non auction owner' do
      test_bid = Bid.new(amount: 3, user: user, auction: auction)
      expect(test_bid).to be_valid
    end

    it 'invalidates a bid created by owner of auction' do
      auction.user_id = 1
      test_bid = Bid.new(amount: 3, user_id: 1, auction: auction)
      expect(test_bid).not_to be_valid
    end
  end
end
