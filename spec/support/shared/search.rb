shared_examples_for "searchable" do
  %w(Questions Answers Comments).each do |type|
    scenario "tries to search #{type}", js: true do
      ThinkingSphinx::Test.run do

        fill_in 'search_body', with: 'Body'
        select type, from: 'search_object'
        click_on 'Search'

        expect(page).to have_content 'test body'
      end
    end
  end

  scenario 'tries to search users', js: true do
    ThinkingSphinx::Test.run do

      fill_in 'search_body', with: user.username
      select 'Users', from: 'search_object'
      click_on 'Search'

      expect(page).to have_content(user.username)
    end
  end

  scenario 'tries to search all', js: true do
    ThinkingSphinx::Test.run do

      fill_in 'search_body', with: 'test body'
      select 'All', from: 'search_object'
      click_on 'Search'

      expect(page).to have_content(comment.body)
      expect(page).to have_content(question.title)
      expect(page).to have_content(answer.body)
    end
  end
end
