require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }

  describe '.find_subsribers' do
    let!(:question) { create(:question) }

    context 'there is no subscribes' do
      before { question.subscribes.destroy_all }

      it 'returns false' do
        expect(Subscribe.find_subscribers(question)).to eq false
      end
    end

    context 'there are subscribers' do
      let!(:subscribe) { create(:subscribe, question: question) }

      it 'returns collection of users' do
        expect(Subscribe.find_subscribers(question)).to have_attributes(length: question.subscribes.length)
      end
    end
  end
end
