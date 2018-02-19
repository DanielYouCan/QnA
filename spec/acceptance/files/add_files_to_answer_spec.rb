require_relative '../acceptance_helper'

feature 'Adds file to answer', %q{
  In order to show details of my answer
  As an author of the answer
  I want to be able to attach file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file to an answer', js: true do
    fill_in 'answer[body]', with: 'My unique answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User adds multiple files to an answer', js: true do
    fill_in 'answer[body]', with: 'My unique answer'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    find('.octicon-plus').click
    inputs = all('input[type="file"]')
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

end
