require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer) }

  describe 'POST #create' do
    sign_in_user

    context 'valid attributes' do
      it 'saves new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'belongs to signed in user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(question.answers.last.user_id).to eq @user.id
      end

      it 're-renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'invalid attributes' do
      it 'does not save answer in the database' do
        expect { post :create, params: { question_id: question.id, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
      end

      it 're-renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do

    before do
      sign_in(answer.user)
    end

    context 'User deletes his/her answer' do

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'shows notice flash message' do
        delete :destroy, params: { id: answer }
        expect(controller).to set_flash[:notice].to('Your answer was successfully deleted.')
      end
    end

    context 'User tries to delete another user answer' do
      let!(:new_user) { create(:user) }
      let!(:new_answer) { create(:answer, question: question, user: new_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: new_answer } }.to_not change(Answer, :count)
      end

      it 'shows warning flash message' do
        delete :destroy, params: { id: new_answer }
        expect(controller).to set_flash.now[:warning].to("You can't delete this answer.")
      end

      it 'renders question show' do
        delete :destroy, params: { id: new_answer }
        expect(response).to render_template :show
      end
    end
  end
end
