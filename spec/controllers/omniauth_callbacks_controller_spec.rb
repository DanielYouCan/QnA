require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe 'GET/POST #facebook' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash_facebook
    end

    context 'user is persisted and authorization is confirmed' do
      let!(:user) { create(:user, email: "mock@mock.com") }
      before { get :facebook }

      it 'signs in user' do
        expect(subject.current_user).to eq user
      end

      it 'sets flash message' do
        expect(controller).to set_flash[:notice]
      end
    end

    context 'user is persisted but authorization is not confirmed' do
      let!(:user) { create(:user, email: "mock@mock.com") }
      let!(:authorization) { create(:authorization, confirmed: false, provider: "facebook", uid: '123456', user: user ) }
      before { get :facebook }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'shows certain flash message' do
        expect(controller).to set_flash[:notice]
      end
    end
  end

  describe 'GET/POST #twitter' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash_twitter
    end

    context 'user is persisted and authorization is confirmed' do
      let!(:user) { create(:user) }
      let!(:authorization) { create(:authorization, provider: "twitter", uid: '123545', user: user ) }
      before { get :facebook }

      it 'signs in user' do
        expect(subject.current_user).to eq user
      end

      it 'sets flash message' do
        expect(controller).to set_flash[:notice]
      end
    end

    context 'user is persisted but authorization is not confirmed' do
      let!(:user) { create(:user) }
      let!(:authorization) { create(:authorization, provider: "twitter", confirmed: false, uid: '123545', user: user ) }
      before { get :facebook }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end

      it 'shows certain flash message' do
        expect(controller).to set_flash[:notice]
      end
    end

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
