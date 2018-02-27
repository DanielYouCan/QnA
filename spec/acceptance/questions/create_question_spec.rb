require_relative '../acceptance_helper'

feature 'User creates question', %q{
  In order to get answer from communty
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test body'
    click_on 'Create'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'Test body'
    expect(page).to have_content 'Question was successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Invalid attributes for question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test'
    click_on 'Create'

    expect(page).to have_content 'Invalid attributes for a new Question'
    expect(page).to have_content 'Title is too short'
    expect(page).to have_content "Body can't be blank"
  end

  context 'multiple sessions' do
    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test body'
        click_on 'Create'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test body'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end
end
