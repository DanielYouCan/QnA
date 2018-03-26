require_relative '../acceptance_helper'

feature 'User deletes his/her comment', %q{
  In order to remove my comment
  As an author of the comment
  I want to be able to delete it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }
  given!(:another_user) { create(:user) }

  scenario 'User is the author of the comment', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      click_on 'delete comment'
      expect(page).to_not have_content comment.body
    end
  end

  scenario 'User is not the aurhor of the comment' do
    sign_in(another_user)
    visit question_path(question)
    within ".answer_#{answer.id}" do
      expect(page).to_not have_link 'delete comment'
    end
  end

  scenario 'Guest user tries to delete comment' do
    visit question_path(question)

    expect(page).to_not have_link 'delete comment'
  end
end
