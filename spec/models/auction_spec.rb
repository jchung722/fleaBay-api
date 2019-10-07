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
  end
end
