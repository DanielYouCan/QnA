require 'rails_helper'

shared_examples_for "votable" do
  it { should have_many :votes }

  let(:model) { described_class }
  let!(:votable) { create(model.to_s.underscore.to_sym) }
  let!(:user) { create(:user) }

  describe "#rating_up!" do
    it 'should a new vote to votable resource' do
      expect { votable.rating_up!(user) }.to change(votable.votes, :count).by(1)
    end

    it 'should create new vote with value 1' do
      votable.rating_up!(user)
      expect(votable.votes.first.value).to eq(1)
    end

    it 'should increase rating by 1' do
      rating = votable.rating
      votable.rating_up!(user)
      expect(votable.rating - rating).to eq(1)
    end

    it 'should return false if user has already voted' do
      votable.rating_up!(user)
      expect(votable.rating_up!(user)).to eq false
    end

    it 'should return false if user is an author' do
      expect(votable.rating_up!(votable.user)).to eq false
    end
  end

  describe "#rating_down!" do
    it 'should a new vote to votable resource' do
      expect { votable.rating_down!(user) }.to change(votable.votes, :count).by(1)
    end

    it 'should create new vote with value -1' do
      votable.rating_down!(user)
      expect(votable.votes.first.value).to eq(-1)
    end

    it 'should decrease rating by 1' do
      rating = votable.rating
      votable.rating_down!(user)
      expect(rating - votable.rating).to eq(1)
    end

    it 'should return false if user has already voted' do
      votable.rating_down!(user)
      expect(votable.rating_down!(user)).to eq false
    end

    it 'should return false if user is an author' do
      expect(votable.rating_down!(votable.user)).to eq false
    end
  end
end
