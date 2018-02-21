require_relative '../acceptance_helper'

feature 'Non-author user votes for question', %q{
  In order to like someone's question
  As a user
  I want to be able to vote against it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Guest tries to vote for a question' do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User tries to vote for his question' do
    sign_in(question.user)
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User votes for question', js: true do
    sign_in(user)
    visit question_path(question)

    within ".question" do
      find('.octicon-thumbsup').click
    end

    within ".question_rating" do
      expect(page).to have_content '1'
    end
  end

  scenario 'User tries to re-vote for question', js: true do
    sign_in(user)
    visit question_path(question)

    within ".question" do
      find('.octicon-thumbsdown').click
      sleep 0.5
      find('.octicon-thumbsup').click
    end

    within '.vote_error_question' do
      expect(page).to have_content 'You have already voted!'
    end
  end
end
