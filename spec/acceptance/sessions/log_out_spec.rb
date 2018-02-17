require_relative '../acceptance_helper'

feature 'User logs out', %q{
  In order to end my session in sytem
  As an authenticated user
  I want to be able to log out
} do

  given(:user) { create(:user) }

  scenario 'User logs out' do
    sign_in(user)

    click_on 'Log out'
    expect(page).to have_content "Signed out successfully."
  end
end
