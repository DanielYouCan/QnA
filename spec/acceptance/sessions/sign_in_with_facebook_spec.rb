require_relative '../acceptance_helper'

feature 'User signs in using facebook account', %q{
  In order to sign without creating an account
  As a user
  I want to be able to sign in with facebook
} do

  context 'User already has a regular account in system' do
    given!(:user) { create(:user, email: "mock@mock.com", confirmed_at: Time.now) }

    scenario 'User signs in with' do
      visit new_user_session_path
      mock_auth_hash_facebook
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content user.username
    end
  end

  context 'User does not have a regular account in system' do
    background do
      visit new_user_session_path
      mock_auth_hash_facebook
      click_on 'Sign in with Facebook'
    end

    scenario 'User confirms his/her account' do
      open_email('mock@mock.com')
      current_email.click_on 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content 'mockuser'
    end
  end
end
