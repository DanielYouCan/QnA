require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  let!(:question) { create(:question) }

  describe "POST #create" do
    context 'user is not subscribed to the question' do
      let(:user) { create(:user) }
      before { sign_in(user) }

      it 'creates subscribe' do
        expect { post :create, params: { question_id: question } }.to change(user.subscribes, :count).by(1)
      end

      it 'shows flash message' do
        post :create, params: { question_id: question}
        expect(controller).to set_flash
      end
    end
  end

  describe "DELETE #destroy" do
    context 'user is author of the question' do
      it 'deletes subscribe' do
        sign_in(question.user)
        expect { delete :destroy, params: { id: question.subscribes.last } }.to change(question.user.subscribes, :count).by(-1)
      end

      it 'shows flash message' do
        delete :destroy, params: { id: question.subscribes.last }
        expect(controller).to set_flash
      end
    end

    context 'user does not subscribed' do
      let(:user) { create(:user) }
      before { sign_in(user) }

      it 'deletes subscribe' do
        post :create, params: { question_id: question }
        expect { delete :destroy, params: { id: question.subscribes.last } }.to change(user.subscribes, :count).by(-1)
      end

      it 'shows flash message' do
        post :create, params: { question_id: question }
        delete :destroy, params: { id: question.subscribes.last }
        expect(controller).to set_flash
      end
    end
  end

end
