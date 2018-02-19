require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'assosiation' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments) }
    it { should belong_to(:user) }
  end

  context 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5) }
    it { should validate_length_of(:title).is_at_least(5) }
  end

  context 'nested attributes' do
    it { should accept_nested_attributes_for :attachments }
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
end
