require 'rails_helper'

feature 'User adds answer to question', %q{
  In order to help other users to solve their issue
  As an authorized user
  I want to be able to create answers for the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user add answer to the question' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'My unique answer'
    click_on 'Answer'

    expect(page).to have_content 'Answer was succefully added'
  end

  scenario 'Guest tries to add answer to the question' do
    visit question_path(question)
    fill_in 'Body', with: 'My unique answer'
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
