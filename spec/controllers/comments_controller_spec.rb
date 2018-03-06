require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  let!(:question) { create(:question) }
  let(:user) { create(:user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:comment) { create(:comment, commentable: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'valid attributes' do
      it 'saves new comment in the database' do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js } }.to change(question.comments, :count).by(1)
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js } }.to change(answer.comments, :count).by(1)
      end

      it 'belongs to signed in user' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js }
        expect(question.comments.last.user_id).to eq user.id
      end

      it 're-renders create view' do
        post :create, params: { answer_id: answer, comment: attributes_for(:comment), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'invalid attributes' do
      it 'does not save answer in the database' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), format: :js } }.to_not change(Comment, :count)
      end

      it 're-renders create view' do
        post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PUT #update' do
    before do
      sign_in(comment.user)
    end

    it 'assings the requested comment to @comment' do
      put :update, params: { id: comment, question_id: question, comment: attributes_for(:comment), format: :js  }
      expect(assigns(:comment)).to eq comment
    end

    it 'changes comment attributes' do
      put :update, params: { id: comment, question_id: question, comment: { body: 'new body' }, format: :js }
      comment.reload
      expect(comment.body).to eq 'new body'
    end

    it 'assigns the commentable' do
      put :update, params: { id: comment, question_id: comment, comment: { body: 'new body' }, format: :js }
      expect(assigns(:commentable)).to eq question
    end

    it 'rerenders the template' do
      put :update, params: { id: comment, question_id: question, comment: attributes_for(:comment), format: :js }
      expect(response).to render_template :update
    end

  end

  describe 'DELETE #destroy' do

    before do
      sign_in(comment.user)
    end

    context 'User deletes his/her comment' do

      it 'deletes the comment' do
        expect { delete :destroy, params: { id: comment, format: :js  } }.to change(Comment, :count).by(-1)
      end

      it 'renders the question' do
        delete :destroy, params: { id: comment, format: :js  }
        expect(response).to render_template :destroy
      end
    end

    context "User tries to delete another user's comment" do
      let!(:new_user) { create(:user) }
      let!(:new_comment) { create(:comment, commentable: answer, user: new_user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: new_comment, format: :js  } }.to_not change(Comment, :count)
      end

      it 'renders question show' do
        delete :destroy, params: { id: new_comment, format: :js  }
        expect(response).to redirect_to root_path
      end
    end
  end

end
