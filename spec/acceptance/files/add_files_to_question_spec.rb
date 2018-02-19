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

  scenario 'User adds file when he is asking question', js: true do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User adds multiple files to a question', js: true do
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

    find('.octicon-plus').click
    inputs = all('input[type="file"]')
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end
