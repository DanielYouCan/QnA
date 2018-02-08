module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def view_index
    visit questions_path
    expect(page).to have_content 'Questions list'

    questions.each do |q|
      expect(page).to have_content q.title
    end
  end
end
