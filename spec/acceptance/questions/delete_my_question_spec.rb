require_relative '../acceptance_helper'

feature 'User deletes his question', %q{
  In order to remove the question from the site
  As an author of the question
  I want to be able to delete the question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  given!(:another_user) { create(:user) }

  scenario 'User is an author of the question' do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'User tries to delete someone else question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Guest tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
