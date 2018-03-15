require_relative '../acceptance_helper'

feature 'Author of question gets an email if new answer was added', %q{
  In order to follow new answers to my question
  As an author
  I want to be able to get updates on it
} do

  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Author gets am email when new answer is added', js: true do
    sign_in(another_user)
    visit question_path(question)

    fill_in 'answer[body]', with: 'New answer'
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_content 'New answer'
    end

    open_email(user.email)
    expect(current_email).to have_content "You got new answer for #{question.title}"
  end

  scenario 'Author unsubscribes from question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
  end

  context 'Unsubscribed author' do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Unsubscribe'
    end

    scenario 'Unsubscribed author does not get an email' do
      sign_in(another_user)
      visit question_path(question)

      fill_in 'answer[body]', with: 'New answer'
      click_on 'Answer'

      open_email(user.email)
      expect(current_email).to be_nil
    end
  end
end
