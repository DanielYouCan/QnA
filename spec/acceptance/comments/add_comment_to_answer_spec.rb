require_relative '../acceptance_helper'

feature 'User adds comment to answer', %q{
  In order to comment someone's answer
  As a user
  I want to be able to add comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  before { visit question_path(question) }

  scenario 'Guest tries to add comennt' do
    expect(page).to_not have_link 'Add comment'
  end

  context 'Authenticated user' do
    before { sign_in(user) }

    scenario 'User sees link to add comment' do
      within ".answer_#{answer.id}" do
        expect(page).to have_link'Add comment'
      end
    end

    scenario 'User adds comment', js: true do
      within ".answer_#{answer.id}" do
        fill_in 'Comment', with: 'new comment'
        click_on 'Add comment'

        expect(page).to have_content 'new comment'
      end
    end
  end


end
