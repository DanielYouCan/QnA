require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  let(:search_all) { { search_object: "All", search_body: "test" } }
  let(:params) { (ActionController::Parameters.new(search_all)).permit(:search_body, :search_object) }
  let(:invalid_search) { { search_object: "Custom", search_body: "test" } }

  context 'valid params' do
    it 'calls search method' do
      expect(Search).to receive(:search_handler).with(params)
      get :search, params: search_all
    end
  end

  context 'invalid params' do
    it 'redirects to root_path' do
      get :search, params: invalid_search
      expect(response).to redirect_to root_path
    end
  end
end
