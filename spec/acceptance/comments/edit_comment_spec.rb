require_relative '../acceptance_helper'

feature 'User edits his/her comment', %q{
  In order to fix my comment
  As an author
  I want to be able to edit my comment
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Guest tries to edit comment' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit comment'
  end

  scenario 'tries to edit someone else answer' do
    sign_in(another_user)
    visit question_path(question)

    within ".answer_#{answer.id}" do
      expect(page).to_not have_link 'Edit comment'
    end
  end

  context 'Author user' do
    before do
      sign_in(comment.user)
      visit question_path(question)
    end

    scenario 'sees link edit' do
      within ".answer_#{answer.id}" do
        expect(page).to have_link 'Edit comment'
      end
    end

    scenario 'tries to edit his/her comment', js: true do
      within ".answer_#{answer.id}" do
        click_on 'Edit comment'

        fill_in 'Comment', with: 'updated comment'
        click_on 'Comment'
        expect(page).to have_content 'updated comment'
        expect(page).to_not have_content comment.body
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'invalid attributes for comment', js: true do
      within ".answer_#{answer.id}" do
        click_on 'Edit comment'

        fill_in 'Comment', with: ''
        click_on 'Comment'
        expect(page).to have_content comment.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end
    end

  end

end
