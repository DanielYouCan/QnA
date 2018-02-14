require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to fix my question
  As an author
  I want to be able to edit it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:another_user) { create(:user) }

  scenario 'Guest tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario 'User tries to edit someone else question' do
    sign_in(another_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Question author' do
    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'User sees edit link' do
      within '.question' do
        expect(page).to have_link 'Edit question'
      end
    end

    scenario 'tries to edit his/her question', js: true do
      click_on 'Edit'
      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Update question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'Invalid attributes', js: true do
      click_on 'Edit'
      within '.question' do
        click_on 'Update question'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_selector 'textarea'
      end
    end
  end
end
