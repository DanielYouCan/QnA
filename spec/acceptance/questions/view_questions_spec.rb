require_relative '../acceptance_helper'

feature 'User views questions list', %q{
  In order to get questions list
  As an user
  I want to be able to view all questions
} do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5) }

  scenario 'Authenticated user can view questions page' do
    sign_in(user)

    view_index
  end

  scenario 'Guest can view questions page' do
    view_index
  end
end
