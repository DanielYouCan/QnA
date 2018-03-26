require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :do, :search }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
    it { should be_able_to :create_user, User }
    it { should be_able_to :set_email, User }
  end

  describe 'for user' do
    let!(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:another_question) { create(:question, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    context 'REST API' do
      it { should be_able_to :me, User }
    end

    context 'search' do
      it { should be_able_to :do, :search }
    end

    describe "User's ability to update resources" do
      it { should be_able_to :update, create(:question, user: user)}
      it { should_not be_able_to :update, create(:question, user: other)}
      it { should be_able_to :update, create(:answer, user: user) }
      it { should_not be_able_to :update, create(:answer, user: other)}
      it { should be_able_to :update, create(:comment, user: user, commentable: question) }
      it { should_not be_able_to :update, create(:comment, user: other, commentable: question) }
    end

    describe "User's ability to destroy resources" do
      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }
      it { should be_able_to :destroy, create(:answer, user: user) }
      it { should_not be_able_to :destroy, create(:answer, user: other) }
      it { should be_able_to :destroy, create(:comment, user: user, commentable: question) }
      it { should_not be_able_to :destroy, create(:comment, user: other, commentable: question) }
      it { should be_able_to :destroy, create(:attachment, attachable: question) }
      it { should_not be_able_to :destroy, create(:attachment, attachable: another_question) }
    end

    describe "User's ability to set answer best" do
      it { should be_able_to :set_best, create(:answer, question: question) }
      it { should_not be_able_to :set_best, create(:answer, question: another_question) }
    end

    describe "User's ability to vote for or against resource" do
      it { should be_able_to [:rating_up, :rating_down], create(:answer, user: other) }
      it { should_not be_able_to [:rating_up, :rating_down], create(:answer, user: user) }
    end

    describe "User's ability to cancel vote" do
      subject(:ability) { Ability.new(author_vote) }

      let(:question_with_votes) { create(:question_with_votes, user: user) }
      let(:author_vote) { question_with_votes.votes.first.user }

      it { should be_able_to :cancel_vote, question_with_votes }
      it { should_not be_able_to :cancel_vote, another_question }
    end

    describe "User's ability to subscribe and unsubscribe to/from questions" do
      subject(:ability) { Ability.new(user) }

      let(:user) { create(:user) }
      let(:question) { create(:question) }

      it { should be_able_to :subscribe, question }
      it { should_not be_able_to :destroy, create(:subscription) }

      context "user can't subscribe" do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it { should_not be_able_to :subscribe, question }
        it { should be_able_to :destroy, subscription }
      end
    end

  end
end
