shared_examples_for "API Authenticable" do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status if there access_token is invalid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for "API Showable" do |attributes|
  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:type) { resource.class.name.downcase }
    let!(:comments) { create_list(:comment, 2, commentable: resource) }
    let!(:attachments) { create_list(:attachment, 3, attachable: resource) }

    before { get "/api/v1/#{type.pluralize}/#{resource.id}", params: { format: :json, access_token: access_token.token } }

    it 'returns 200 status code' do
      expect(response).to be_success
    end

    attributes.each do |attr|
      it "object contains #{attr}" do
        expect(response.body).to be_json_eql(resource.send(attr.to_sym).to_json).at_path("#{type}/#{attr}")
      end
    end

    context 'comments' do
      it "included in object" do
        expect(response.body).to have_json_size(2).at_path("#{type}/comments")
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(comments[0].send(attr.to_sym).to_json).at_path("#{type}/comments/0/#{attr}")
        end
      end
    end

    context 'attachments' do
      it "included in object" do
        expect(response.body).to have_json_size(3).at_path("#{type}/attachments")
      end

      it "contains file_url" do
        expect(response.body).to be_json_eql(attachments[0].file.url.to_json).at_path("#{type}/attachments/2/file_url")
      end
    end
  end
end
