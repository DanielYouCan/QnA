require_relative '../acceptance_helper'

feature 'Author deletes file from his/her question', %q{
  In order to remove file from the answer
  As an author of the answer
  I want to be able to delete it
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
  end

  scenario 'User delets file from his/her answer', js: true do
    within '.question' do
      find('.octicon-trashcan').click
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

end
