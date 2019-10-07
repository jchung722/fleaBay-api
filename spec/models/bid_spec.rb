require 'rails_helper'

RSpec.describe Bid, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:auction) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
  end
end
