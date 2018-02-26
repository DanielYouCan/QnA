require_relative '../acceptance_helper'

feature 'User adds comment to a question', %q{
  In order to comment someone's question
  As a user
  I want to be able to add comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Guest tries to add comennt' do
    visit question_path(question)
    expect(page).to_not have_link 'Add comment'
  end

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User sees link to add comment' do
      within ".question" do
        expect(page).to have_link 'Add comment'
      end
    end

    scenario 'User adds comment', js: true do
      within ".question" do
        click_on 'Add comment'
        fill_in 'create_comment_body', with: 'new comment'
        click_on 'Comment'

        expect(page).to have_content 'new comment'
      end
    end

    scenario 'Invalid attributes for comment', js: true do
      within ".question" do
        click_on 'Add comment'
        click_on 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end