require 'rails_helper'

shared_examples_for 'voted' do
  let(:controller) { described_class }
  let(:votable) { create(controller.to_s.underscore.split('_')[0].singularize.to_sym) }
  let!(:user) { create(:user) }

  before { sign_in(user) }

  describe 'PATCH #rating_up' do
    before { patch :rating_up, params: { id: votable.id, format: :json } }

    it 'gets json response' do
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq (assigns(:votable)).to_json
    end

    it 'returns id and forbidden status if rating_up! returns false' do
      patch :rating_up, params: { id: votable.id, format: :json }
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq assigns(:votable).id.to_s
      expect(response.status).to eq 403
    end
  end

  describe 'PATCH #rating_down' do
    before { patch :rating_down, params: { id: votable.id, format: :json } }

    it 'gets json response' do
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq (assigns(:votable)).to_json
    end

    it 'returns id and forbidden status if rating_down! returns false' do
      patch :rating_down, params: { id: votable.id, format: :json }
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq assigns(:votable).id.to_s
      expect(response.status).to eq 403
    end
  end

  describe 'PATCH #cancel_vote' do
    it 'gets json response' do
      patch :rating_up, params: { id: votable.id, format: :json }
      patch :cancel_vote, params: { id: votable.id, format: :json }
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq (assigns(:votable)).to_json
    end

    it 'returns id and forbidden status if cancel_vote! returns false' do
      patch :cancel_vote, params: { id: votable.id, format: :json }
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq assigns(:votable).id.to_s
      expect(response.status).to eq 403
    end
  end

end
