require 'rails_helper'

RSpec.describe 'Answers API', type: 'request' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answers[0].send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/1/answers', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    subject { build(:answer) }
    it_behaves_like 'API Authenticable'
    it_behaves_like 'API Showable', %w(id body created_at updated_at question_id)

    def do_request(options = {})
      get '/api/v1/answers/1', params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let(:user) { User.find(access_token.resource_owner_id) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { format: :json, answer: attributes_for(:answer), access_token: access_token.token } }

      it 'returns 201 status' do
        expect(response.status).to eq 201
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(question.answers.last.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end

  def do_request(options = {})
    post '/api/v1/questions/1/answers', params: { format: :json, question: attributes_for(:question) }.merge(options)
  end
end
