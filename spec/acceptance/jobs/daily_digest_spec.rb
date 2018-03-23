require_relative '../acceptance_helper'

feature 'User gets digest of all questions for today', %q{
  In order to know what are the newest questions
  As an user
  I want to be able get them by email
} do

  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }
  given!(:yesterday_questions) { create_list(:question, 2, created_at: Date.yesterday.to_datetime) }

  background do
    User.find_each { |user| DailyMailer.digest(user).deliver_now }
  end

  scenario 'All users get digest' do
    User.find_each do |user|
      open_email(user.email)
      expect(current_email).to have_content(user.username)
    end
  end

  context 'User gets digest with questions only for today' do
    before { open_email(user.email) }

    scenario "user gets list of today's questions" do
      expect(current_email).to have_css('li', count: questions.count)
    end

    scenario "user doesn't get questions out of today's date" do
      yesterday_questions.pluck(:title).each do |title|
        expect(current_email).to_not have_content(title)
      end
    end
  end
end
