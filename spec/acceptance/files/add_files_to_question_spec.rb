require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to show details of the problem
  As an author of the question
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when he is asking question' do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'spec_helper.rb'
  end
end
