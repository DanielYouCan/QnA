require_relative '../acceptance_helper'

feature 'User cancels his/her vote', %q{
  In order to revote for or agaist resource
  As a voted user
  I want to be able to cancel it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  background do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      find('.octicon-thumbsup').click
    end
    sleep 0.5

    within ".answer_#{answer.id}" do
      find('.octicon-thumbsdown').click
    end
    sleep 0.5
  end

  scenario 'User cancels his vote for a question', js: true do
    rating = question.reload.rating
    within '.question' do
      click_on 'cancel vote'
    end

    within '.question_rating' do
      expect(page).to have_content(rating - 1)
    end
  end

  scenario 'User cancels his vote against an answer', js: true do
    rating = answer.reload.rating
    within ".answer_#{answer.id}" do
      click_on 'cancel vote'
    end

    within ".answer_#{answer.id}_rating" do
      expect(page).to have_content(rating + 1)
    end
  end
end
