require_relative '../acceptance_helper'

feature 'User deletes attachment from his answer', %q{
  In order to remove attachment from my answer
  As an author of the answer
  I want to be able to delete it
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit(question_path(question))

    fill_in 'answer[body]', with: 'My unique answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Answer'
  end

  scenario 'Author deletes attachment from his/her answer', js: true do
    within '.answers' do
      find('.octicon-trashcan').click
      expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
