require_relative '../acceptance_helper'

feature 'User subscribes to question', %q{
  In order to get updates on answers
  As an user
  I want to be able to subscribe to questions
} do

  given!(:question) { create(:question) }

  context 'guest' do
    scenario "guest doesn't see links to subscribe" do
      visit question_path(question)
      expect(page).to_not have_content 'Subscribe to question'
      expect(page).to_not have_content 'Unsubscribe'
    end
  end

  describe 'user subscriptions' do
    given!(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'user subscribes' do
      scenario 'user subscribes to question' do
        expect(page).to have_content 'Subscribe to question'
        click_on 'Subscribe to question'
        expect(page).to have_content 'Unsubscribe'
      end

      scenario 'user gets email', js: true do
        click_on 'Subscribe to question'

        fill_in 'answer[body]', with: 'New answer'
        click_on 'Answer'

        within '.answers' do
          expect(page).to have_content 'New answer'
        end

        open_email(user.email)
        expect(current_email).to have_content "You got new answer for #{question.title}"
      end
    end

    context 'user unsubscribes' do
      background do
        click_on 'Subscribe to question'
      end

      scenario 'user unsubscribes from question' do
        expect(page).to have_content 'Unsubscribe'
        click_on 'Unsubscribe'
        expect(page).to have_content 'Subscribe to question'
      end

      scenario "user doesn't get email", js: true do
        click_on 'Unsubscribe'

        fill_in 'answer[body]', with: 'New answer'
        click_on 'Answer'

        within '.answers' do
          expect(page).to have_content 'New answer'
        end

        open_email(user.email)
        expect(current_email).to be_nil
      end
    end

  end


end
