require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    before do
      sign_in(question.user)
    end

    it 'deletes attachment' do
      expect { delete :destroy, params: { id: attachment, format: :js } }.to change(Attachment, :count).by(-1)
    end

    it 're-renders destroy view' do
      delete :destroy, params: { id: attachment, format: :js }
      expect(response).to render_template :destroy
    end
  end
end
