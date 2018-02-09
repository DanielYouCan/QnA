require 'rails_helper'

feature 'User signs up', %q{
  In order to get account on the site
  As an user
  I want to be able to register
} do

  given(:user) { create(:user) }

  scenario 'Valid attributes for registration' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newemail@test.com'
    fill_in 'Password', with: 'newpass123'
    fill_in 'Password confirmation', with: 'newpass123'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User already exists' do
    visit new_user_registration_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Password less than 6 symbols' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newemail@test.com'
    fill_in 'Password', with: '12345'
    fill_in 'Password confirmation', with: '12345'
    click_on 'Sign up'

    expect(page).to have_content 'Password is too short'
  end

  scenario 'Passwords do not match' do
    visit new_user_registration_path

    fill_in 'Email', with: 'newemail@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123457'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Invalid email' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test-test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
  end
end
