require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'assosiation' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  context 'validation' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5) }
  end

  describe '#is_best?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, best: true) }
    let!(:another_answer) { create(:answer) }

    it 'should return true if answer is best' do
      expect(answer).to be_best
    end

    it 'should return false if answer is not best' do
      expect(another_answer).to be_not_best
    end
  end
end
