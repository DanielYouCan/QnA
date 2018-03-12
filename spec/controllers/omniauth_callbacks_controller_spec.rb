require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe 'GET/POST #facebook' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash_facebook
    end

    let!(:user) { create(:user, email: "mock@mock.com") }
    let(:provider) { "facebook" }
    it_behaves_like "Oauthenticable"

  end

  describe 'GET/POST #twitter' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash_twitter
    end

    let!(:user) { create(:user) }
    let(:provider) { "twitter" }
    it_behaves_like "Oauthenticable"

    context 'user is not persisted' do
      before { get :twitter }

      it 'redirects to set_email path' do
        expect(response).to redirect_to users_set_email_path
      end

      it 'saves info about request in session store' do
        expect(session["devise.provider_data"]).to eq request.env['omniauth.auth'].except("extra")
      end
    end
  end
end
