require 'rails_helper'

RSpec.describe 'Answers API', type: 'request' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/1/answers', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is invalid' do
        get '/api/v1/questions/1/answers', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

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
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/answers/1', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is invalid' do
        get '/api/v1/answers/1', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:attachments) { create_list(:attachment, 3, attachable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(2).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comments[0].send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(3).at_path("answer/attachments")
        end

        it "contains file_url" do
          expect(response.body).to be_json_eql(attachments[0].file.url.to_json).at_path("answer/attachments/2/file_url")
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post '/api/v1/questions/1/answers', params: { format: :json, question: attributes_for(:question) }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is invalid' do
        post '/api/v1/questions/1/answers', params: { format: :json, question: attributes_for(:question), access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

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
end
