require 'rails_helper'

RSpec.describe User, type: :model do

  context 'assosiation' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:votes) }
    it { should have_many(:comments) }
    it { should have_many(:authorizations).dependent(:destroy) }
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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { mock_auth_hash_facebook }

    context 'user already has authorization with social network' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'provider does not return an email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: '' }) }

        it 'returns unpersisted user' do
          expect(User.find_for_oauth(auth).persisted?).to eq false
        end
      end

      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { (User.find_for_oauth(auth))}.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { (User.find_for_oauth(auth))}.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'newuser@user.com', nickname: 'mockuser' }) }

        it 'creates new user' do
          expect { (User.find_for_oauth(auth)) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  describe '.create_user_for_network!' do
    let(:session) {
      { "provider" => "twitter", "uid" => "123456",
      "info"=> { "nickname" => "mockuser", "name" => "Mock User",
      "email" => nil } }
    }

    context 'Email is blank' do
      let(:params) { { email: '' } }

      it 'returns false' do
        expect(User.create_user_for_network!(params, session)).to eq false
      end
    end

    context 'User with given email exists' do
      let(:user) { create(:user) }
      let(:params) { { email: user.email } }

      it 'creates unconfirmed authorization' do
        expect { User.create_user_for_network!(params, session) }.to change(user.authorizations.where(confirmed: false), :count).by(1)
      end
    end

    context 'User does not exist' do
      let(:params) { { email: 'mock@test.com' } }

      it 'creates new user' do
        expect { User.create_user_for_network!(params, session) }.to change(User, :count).by(1)
      end
    end
  end

  describe '#create_authorization' do
    let(:user) { create(:user) }
    let(:auth) { mock_auth_hash_twitter }

    it 'creates authorization for user' do
      expect { user.create_authorization(auth) }.to change(user.authorizations, :count).by(1)
    end

    it 'creates unconfirmed authorization if parametr provided' do
      expect { user.create_authorization(auth, unconfirmed: true) }.to change(user.authorizations.where(confirmed: false), :count).by(1)
    end
  end

  describe '#create_unconfirmed_authorization' do
    let(:user) { create(:user) }
    let(:auth) { mock_auth_hash_twitter }

    it 'creates unconfirmed authorization' do
      expect { user.create_unconfirmed_authorization(auth) }.to change(user.authorizations.where(confirmed: false), :count).by(1)
    end

    it 'sends email with confirmation link to user' do
      expect { user.create_unconfirmed_authorization(auth) }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
