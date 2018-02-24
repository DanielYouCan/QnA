require_relative '../acceptance_helper'

feature 'User adds answer to question', %q{
  In order to help other users to solve their issue
  As an authorized user
  I want to be able to create answers for the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user adds answer to the question', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'answer[body]', with: 'My unique answer'
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_content 'My unique answer'
    end
  end

  scenario 'Guest tries to add answer to the question', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
    expect(page).to_not have_link 'Answer'
  end

  scenario 'Invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'Abc'
    click_on 'Answer'

    expect(page).to have_content 'Body is too short'
  end

  context 'multiple sessions' do
    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'answer[body]', with: 'My unique answer'
        click_on 'Answer'

        within '.answers' do
          expect(page).to have_content 'My unique answer'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My unique answer'
      end
    end
  end

end
