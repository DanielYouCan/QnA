require 'rails_helper'

RSpec.describe 'Questions API', type: 'request' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is invalid' do
        get '/api/v1/questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/1/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/1/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/1/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/1/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/1', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if there access_token is invalid' do
        get '/api/v1/questions/1', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:attachments) { create_list(:attachment, 3, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("question/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comments[0].send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(3).at_path("question/attachments")
        end

        it "contains file_url" do
          expect(response.body).to be_json_eql(attachments[0].file.url.to_json).at_path("question/attachments/2/file_url")
        end
      end
    end

    describe 'POST /create' do
      context 'unauthorized' do
        it 'returns 401 status if there is no access_token' do
          post '/api/v1/questions', params: { format: :json, question: attributes_for(:question) }
          expect(response.status).to eq 401
        end

        it 'returns 401 status if there access_token is invalid' do
          post '/api/v1/questions', params: { format: :json, question: attributes_for(:question), access_token: '1234' }
          expect(response.status).to eq 401
        end
      end

      context 'authorized' do
        let(:access_token) { create(:access_token) }
        let(:user) { User.find(access_token.resource_owner_id) }

        before { post '/api/v1/questions', params: { format: :json, question: attributes_for(:question), access_token: access_token.token } }

        it 'returns 201 status' do
          expect(response.status).to eq 201
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(user.questions.last.send(attr.to_sym).to_json).at_path("question/#{attr}")
          end
        end

        it 'question object contains short_title' do
          expect(response.body).to be_json_eql(user.questions.last.title.truncate(10).to_json).at_path("question/short_title")
        end
      end
    end
  end
end
