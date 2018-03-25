require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "commentable"
  it_behaves_like "votable"
  it_behaves_like "modelable"

  context 'assosiation' do
    it { should belong_to(:question) }
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

  describe 'send to subscribers' do
    let!(:question) { create(:question) }
    subject { build(:answer, question: question) }

    it 'should send answer to subscribers' do
      expect(NewAnswerEmailDistributionJob).to receive(:perform_later).with(subject.question, subject)
      subject.save!
    end
  end
end
