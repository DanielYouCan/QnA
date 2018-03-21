require 'rails_helper'

RSpec.describe 'Search class' do
  describe '#search_handler' do
    let!(:question) { create(:question, title: "SphinxTest") }
    let!(:answer) { create(:answer, body: "SphinxTest") }
    let!(:search_all) { { search_object: "All", search_body: question.title } }
    let!(:search_questions) { { search_object: "Questions", search_body: question.title } }

    it 'calls ThinkingSphinx.search method' do
      expect(ThinkingSphinx).to receive(:search).with(search_all[:search_body])
      Search.search_handler(search_all)
    end

    it 'calls Question.search method' do
      expect(Question).to receive(:search).with(search_questions[:search_body])
      Search.search_handler(search_questions)
    end
  end
end
