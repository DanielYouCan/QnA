require_relative '../acceptance_helper'

feature 'Non-author user votes for answer', %q{
  In order to like someone's answer
  As a user
  I want to be able to vote for it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Guest tries to vote for an answer' do
    visit question_path(question)

    within ".answer_#{answer.id}" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User tries to vote for his answer' do
    sign_in(answer.user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      expect(page).to_not have_selector('.vote')
    end
  end

  scenario 'User votes for answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      find('.octicon-thumbsup').click
    end

    within ".answer_#{answer.id}_rating" do
      expect(page).to have_content '1'
    end
  end

  scenario 'User tries to re-vote for answer', js: true do
    sign_in(user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      find('.octicon-thumbsup').click
      sleep 0.5
      find('.octicon-thumbsup').click
    end

    within ".vote_error_#{answer.id}" do
      expect(page).to have_content 'You have already voted!'
    end
  end
end
