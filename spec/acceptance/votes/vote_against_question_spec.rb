require_relative '../acceptance_helper'

feature 'Non-author user votes against question', %q{
  In order to dislike someone's question
  As a user
  I want to be able to vote against it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Guest tries to vote against a question' do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User tries to vote against his question' do
    sign_in(question.user)
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User votes against question', js: true do
    sign_in(user)
    visit question_path(question)

    within ".question" do
      find('.octicon-thumbsdown').click
    end

    within ".question_rating" do
      expect(page).to have_content '-1'
    end
  end
end
