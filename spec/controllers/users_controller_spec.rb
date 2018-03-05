require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #set_email' do
    before { get :set_email }

    it 'renders show view' do
      expect(response).to render_template :set_email
    end
  end

  describe 'POST #create_user' do
    before { session["devise.provider_data"] = mock_auth_hash_twitter }

    context 'valid email' do
      it 'redirects to login page' do
        post :create_user, params: { email: 'test@mail.ru' }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'invalid email' do
      it 'renders set_email view' do
        post :create_user, params: { email: '' }
        expect(response).to render_template :set_email
      end
    end
  end
end
