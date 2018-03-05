require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  describe 'GET #set_confirmed' do
    let(:authorization) { create(:authorization, confirmed: false, confirmation_token: 'mytoken') }

    it 'assigns the requested authorization to @authorization' do
      get :set_confirmed, params: { confirmation_token: authorization.confirmation_token }
      expect(assigns(:authorization)).to eq authorization
    end

    it 'redirects to new_user_session_path' do
      get :set_confirmed, params: { confirmation_token: authorization.confirmation_token }
      expect(response).to redirect_to new_user_session_path
    end
  end
end
