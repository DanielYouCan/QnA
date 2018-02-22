require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "votable"
  
  context 'assosiation' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:attachments) }
  end

  context 'validation' do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5) }
  end

  context 'nested attributes' do
    it { should accept_nested_attributes_for :attachments }
  end

  describe '#set_best' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let!(:previous_best_answer) { create(:answer, question: question, best: true) }

    it 'should set new answer as best' do
       answer.set_best!
       expect(answer.reload).to be_best
    end

    it 'should set previous best answer as not best' do
      answer.set_best!
      expect(previous_best_answer.reload).to_not be_best
    end
  end
end
