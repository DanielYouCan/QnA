require_relative '../acceptance_helper'

feature 'Non-author user votes against answer', %q{
  In order to dislike someone's answer
  As a user
  I want to be able to vote against it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Guest tries to vote against an answer' do
    visit question_path(question)

    within ".answer_#{answer.id}" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User tries to vote against his answer' do
    sign_in(answer.user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User votes against answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      find('.octicon-thumbsdown').click
    end

    within ".answer_#{answer.id}_rating" do
      expect(page).to have_content '-1'
    end
  end

  scenario 'User tries to re-vote against answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      find('.octicon-thumbsup').click
      sleep 0.5
      find('.octicon-thumbsdown').click
    end

    within ".vote_error_#{answer.id}" do
      expect(page).to have_content 'You have already voted!'
    end
  end
end
