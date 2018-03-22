require_relative '../acceptance_helper'

feature 'User tries to search', %q{
  In order to find desirable information
  As an user
  I want to be able to search
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, body: 'test body') }
  given!(:answer) { create(:answer, body: 'test body') }
  given!(:comment) { create(:comment, commentable: question, body: 'test body') }

  background { visit questions_path }

  context 'guest' do
    it_behaves_like 'searchable'
  end

  context 'user' do
    background { sign_in(user) }

    it_behaves_like 'searchable'
  end

end
