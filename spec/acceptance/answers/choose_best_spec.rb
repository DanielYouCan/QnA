require_relative  '../acceptance_helper'

feature 'Author chooses best answer', %q{
  In order to appreciate helpful answers
  As an author
  I want to be able to choose best answer
} do

   given!(:user) { create(:user) }
   given!(:question) { create(:question) }
   given!(:another_user) { create(:user) }
   given!(:answer) { create(:answer, question: question, user: another_user ) }

   scenario 'Guest tries to choose best answer' do
     visit question_path(question)

     expect(page).to_not have_link 'Choose best'
   end

   scenario 'Non-author tries to choose best answer' do
     sign_in(another_user)
     visit question_path(question)

     expect(page).to_not have_link 'Choose best'
   end

   describe 'Author of the question' do
     before do
       sign_in(question.user)
       visit question_path(question)
     end

     scenario 'Sees choose best link' do
       within '.answers' do
         expect(page).to have_link 'Choose best'
       end
     end

     scenario 'Chooses answer as best', js: true do
       click_on 'Choose best'

       within '.answers' do
         expect(page).to_not have_link 'Choose best'
         expect(page).to have_css('svg.octicon-check', count: 1)
       end
     end

   end
end
