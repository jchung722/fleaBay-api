require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should have_secure_password }

    it 'validates an email with correct format' do
      test_user = User.new(email: 'tester@gmail.com', password: 'test')
      expect(test_user).to be_valid
    end

    it 'invalidates an email with incorrect format' do
      test_user = User.new(email: 'bademail', password: 'test')
      expect(test_user).not_to be_valid
    end
  end
end
