require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "commentable"
  it_behaves_like "votable"
  it_behaves_like "modelable"

  context 'assosiation' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:subscribes).dependent(:destroy) }
  end

  context 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(5) }
  end

  describe '#has_best_answer?' do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, best: true) }
    let!(:another_question) { create(:question) }

    it 'should return true if question has only one best answer' do
      expect(question).to be_has_best_answer
    end

    it "should return false if question hasn't only one best answer" do
      expect(another_question).to_not be_has_best_answer
    end
  end

  describe '#best_answer' do
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, best: true) }
    let!(:another_question) { create(:question) }
    let!(:another_answer) { create(:answer, question: another_question) }

    it 'should return answer if question has best answer' do
      expect(question.best_answer).to eq(answer)
    end

    it "should return nil if question doesn't have best answer" do
      expect(another_question.best_answer).to eq(nil)
    end
  end

  describe 'subscribe author' do
    subject { build(:question) }

    it 'should create new subcribe' do
      subject.save!
      expect(subject.subscribes).to_not be_empty
    end

  end
end
