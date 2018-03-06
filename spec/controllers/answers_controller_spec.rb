require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let!(:question) { create(:question) }
  let(:user) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'valid attributes' do
      it 'saves new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'belongs to signed in user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(question.answers.last.user_id).to eq user.id
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

  describe 'PUT #update' do
    before do
      sign_in(answer.user)
    end

    it 'assings the requested answer to @answer' do
      put :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js  }
      expect(assigns(:answer)).to eq answer
    end

    it 'changes question attributes' do
      put :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'assigns the question' do
      put :update, params: { id: answer, question_id: question, answer: { body: 'new body' }, format: :js }
      expect(assigns(:question)).to eq question
    end

    it 'redirects to the updated question' do
      put :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(response).to render_template :update
    end

  end

  describe 'DELETE #destroy' do

    before do
      sign_in(answer.user)
    end

    context 'User deletes his/her answer' do

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, format: :js  } }.to change(Answer, :count).by(-1)
      end

      it 'renders the question' do
        delete :destroy, params: { id: answer, format: :js  }
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete another user answer' do
      let!(:new_user) { create(:user) }
      let!(:new_answer) { create(:answer, question: question, user: new_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: new_answer, format: :js  } }.to_not change(Answer, :count)
      end

      it 'redirects to root path' do
        delete :destroy, params: { id: new_answer, format: :js  }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #set_best' do
    let!(:new_user) { create(:user) }
    let!(:new_answer) { create(:answer, question: question, user: new_user) }

    before { sign_in(question.user) }

    context 'User chooses best answer' do
      it 'adds answer as best' do
        expect { patch :set_best, params: { id: new_answer, format: :js } }.to change(question.answers.best, :count).by(1)
      end

      it 'renders question show' do
        patch :set_best, params: { id: new_answer, format: :js }
        expect(response).to render_template :set_best
      end
    end

    context 'User sets another answer as best' do
      let!(:another_answer) { create(:answer, question: question, user: new_user, best: true) }

      it 'set another answer as best' do
        expect { patch :set_best, params: { id: new_answer, format: :js } }.to_not change(question.answers.best, :count)
      end

      it 'changes old best answer to not best' do
        patch :set_best, params: { id: new_answer, format: :js }
        expect(another_answer.reload.best).to eq false
        expect(new_answer.reload.best).to eq true
      end

      it 'renders question show' do
        patch :set_best, params: { id: new_answer, format: :js }
        expect(response).to render_template :set_best
      end
    end
  end
end
