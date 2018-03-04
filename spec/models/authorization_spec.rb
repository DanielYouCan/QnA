require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to(:user) }

  let!(:authorization) { create(:authorization, confirmed: false, confirmation_token: 'mytoken') }

  describe '#set_confirmed!' do
    it 'sets confirmed to true' do
      authorization.set_confirmed!
      expect(authorization).to be_confirmed
    end

    it 'sets confirmation token to nil' do
      authorization.set_confirmed!
      expect(authorization.confirmation_token).to eq nil
    end
  end

  describe '#send_confirmation' do
    it 'sets confirmation_token' do
      authorization.send_confirmation
      expect(authorization.confirmation_token).to_not eq nil
    end

    it 'sends confirmation letter' do
      expect { authorization.send_confirmation }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
  end
end
