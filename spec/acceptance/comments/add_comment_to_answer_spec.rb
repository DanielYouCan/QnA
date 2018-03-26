require_relative '../acceptance_helper'

feature 'User adds comment to answer', %q{
  In order to comment someone's answer
  As a user
  I want to be able to add comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Guest tries to add comennt' do
    visit question_path(question)
    expect(page).to_not have_link 'add a comment'
  end

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User sees link to add comment' do
      within ".answer_#{answer.id}" do
        expect(page).to have_link 'add a comment'
      end
    end

    scenario 'User adds comment', js: true do
      within ".answer_#{answer.id}" do
        click_on 'add a comment'
        fill_in 'create_comment_body', with: 'new comment'
        click_on 'Comment'

        expect(page).to have_content 'new comment'
      end
    end

    scenario 'Invalid attributes for comment', js: true do
      within ".answer_#{answer.id}" do
        click_on 'add a comment'
        click_on 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  context 'multiple sessions' do
    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".answer_#{answer.id}" do
          click_on 'add a comment'
          fill_in 'create_comment_body', with: 'new comment'
          click_on 'Comment'

          expect(page).to have_content 'new comment'
        end
      end

      Capybara.using_session('guest') do
        within ".answer_#{answer.id}" do
          expect(page).to have_content 'new comment'
        end
      end
    end
  end
end
