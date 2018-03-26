require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix my answer
  As an author
  I want to be able to edit answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:another_user) { create(:user) }

  scenario 'Guest tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'edit'
  end

  scenario 'tries to edit someone else answer' do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'edit'
    end
  end

  describe 'Author user' do
    before do
      sign_in(answer.user)
      visit question_path(question)
    end

    scenario 'sees link edit' do
      within '.answers' do
        expect(page).to have_link 'edit'
      end
    end

    scenario 'tries to edit his/her answer', js: true do
      click_on 'edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Update Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'invalid attributes for answer', js: true do
      click_on 'edit'
      within '.answers' do
        fill_in 'Answer', with: ''
        click_on 'Update Answer'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
      end
    end

  end


end
