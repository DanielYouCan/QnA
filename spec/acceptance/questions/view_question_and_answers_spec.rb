require_relative '../acceptance_helper'

feature 'User views question and answers to it', %q{
  In order to get answers for the question
  As an user
  I want to be able to view its answers
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3) }

  scenario 'Authenticated user views question and its answers' do
    sign_in(user)

    view_question
  end

  scenario 'Guest views question and its answers' do
    visit question_path(question)

    view_question
  end
end
