require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'builds new attachment for the answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for the question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    before { @user }

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'belongs to signed in user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user_id).to eq @user.id
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'shows notice flash message' do
        post :create, params: { question: attributes_for(:question) }
        expect(controller).to set_flash[:notice].to('Your question was successfully created.')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assings the requested question to @question' do
        put :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        put :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        put :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { put :update, params: { id: question, question: { title: 'new title', body: nil }, format: :js } }

      it 'does not update the question' do
        old_title = question.title
        question.reload
        expect(question.title).to eq old_title
        expect(question.body).to eq 'MyText'
      end

      it 'redirects to the updated question' do
        put :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    let(:my_question) { create(:question, user: @user )}

    before do
       my_question
       question
     end

    context 'user is the author of the question' do
      it 'deletes question' do
        expect { delete :destroy, params: { id: my_question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: my_question }
        expect(response).to redirect_to questions_path
      end

      it 'shows notice flash message' do
        delete :destroy, params: { id: my_question }
        expect(controller).to set_flash[:notice].to('Your question was successfully deleted.')
      end
    end

    context 'user is not the author of the question' do
      it 'does not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'shows a warning flash message' do
        delete :destroy, params: { id: question }
        expect(controller).to set_flash.now[:warning].to("You can't delete this question.")
      end

      it 're-renders show view' do
        delete :destroy, params: { id: question }
        expect(response).to render_template :show
      end
    end

  end
end
