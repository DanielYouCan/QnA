require 'rails_helper'

RSpec.describe User, type: :model do

  context 'assosiation' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:votes) }
    it { should have_many(:comments) }
  end

  context 'validation' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe '#author_of?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user) }
    let!(:another_user) { create(:user) }

    it 'should return true if item.user equal current_user' do
      expect(user).to be_author_of(question)
    end

    it 'should return false if item.user does not equal current_user' do
      expect(another_user).to_not be_author_of(answer)
    end
  end
end
