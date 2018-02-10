require 'rails_helper'

RSpec.describe User, type: :model do

  context 'assosiation' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  context 'validation' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe '#is_author' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user) }
    let!(:another_user) { create(:user) }

    it 'should return true if item.user equal current_user' do
      expect(user.is_author?(question)).to eq true
      expect(user.is_author?(answer)).to eq true
    end

    it 'should return false if item.user does not equal current_user' do
      expect(another_user.is_author?(question)).to eq false
      expect(another_user.is_author?(answer)).to eq false
    end
  end
end
