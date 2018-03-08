require 'rails_helper'

RSpec.describe 'Profile API', type: 'request' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        login_as(me)
        get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesn't contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /all' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/all', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is invalid' do
        get '/api/v1/profiles/all', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        login_as(me)
        get '/api/v1/profiles/all', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains #{attr}" do
          response.body[1...-2].split('},').each_with_index do |profile, index|
            expect("#{profile}}").to be_json_eql(users[index].send(attr.to_sym).to_json).at_path(attr)
          end
        end
      end

      it "doesn't return resource owner user" do
        response.body[1...-2].split('},').each_with_index do |profile|
          expect("#{profile}}").to_not be_json_eql(me.id.to_json).at_path('id')
        end
      end

      %w(password encrypted_password).each do |attr|
        it "doesn't contain #{attr}" do
          response.body[1...-2].split('},').each_with_index do |profile, index|
            expect("#{profile}}").to_not have_json_path(attr)
          end
        end
      end
    end
  end
end
