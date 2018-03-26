require_relative '../acceptance_helper'

feature 'User deletes his/her answer', %q{
  In order to remove my answer
  As an author of the answer
  I want to be able to delete it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:another_user) { create(:user) }

  scenario 'User is the author of the answer', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'delete answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'User is not the aurhor of the answer' do
    sign_in(another_user)

    visit question_path(question)
    expect(page).to_not have_link 'delete answer'
  end

  scenario 'Guest user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'delete answer'
  end
end
