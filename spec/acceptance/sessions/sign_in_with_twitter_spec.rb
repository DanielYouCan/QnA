require_relative '../acceptance_helper'

feature 'User signs in using twitter account', %q{
  In order to sign without creating an account
  As a user
  I want to be able to sign in with twitter
} do

  given(:user) { create(:user) }

  background do
     visit new_user_session_path
     mock_auth_hash_twitter
     click_on 'Sign in with Twitter'
   end

  context 'User does not have a regular account in system' do
    scenario 'User sees buttom Set email' do
      expect(page).to have_selector(:link_or_button, 'Set email')
    end

    scenario 'User gets email' do
      fill_in 'email', with: "myemail@gmail.com"
      click_on 'Set email'
      open_email('myemail@gmail.com')
      expect(current_email).to have_link 'Confirm my account'
    end

    scenario 'User confirms his/her email' do
      fill_in 'email', with: "myemail@gmail.com"
      click_on 'Set email'
      open_email('myemail@gmail.com')
      current_email.click_on 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content 'mockuser'
    end

  end

  context 'User already has a regular account in system' do
    scenario 'User sees buttom Set email' do
      expect(page).to have_selector(:link_or_button, 'Set email')
    end

    scenario 'User gets email' do
      fill_in 'email', with: user.email
      click_on 'Set email'
      open_email(user.email)
      expect(current_email).to have_link 'Confirm my email'
    end

    scenario 'User confirms his/her email' do
      fill_in 'email', with: user.email
      click_on 'Set email'
      open_email(user.email)
      current_email.click_on 'Confirm my email'
      expect(page).to have_content 'You have confrimed your email! Now you can sign in using Twitter'
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content user.username
    end
  end

  context 'User enters someone else email' do
    scenario 'User can not confirm his/her email' do
      fill_in 'email', with: user.email
      click_on 'Set email'
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      expect(page).to have_content 'Confirm your email for signing in with Twitter'
      expect(page).to_not have_content user.username
    end
  end
end
