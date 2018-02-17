require_relative  '../acceptance_helper'

feature 'Author sets best answer', %q{
  In order to appreciate helpful answers
  As an author
  I want to be able to set best answer
} do

   given!(:user) { create(:user) }
   given!(:question) { create(:question) }
   given!(:another_user) { create(:user) }
   given!(:first_answer) { create(:answer, question: question, user: another_user ) }
   given!(:previous_best_answer) { create(:answer, question: question, user: another_user, best: true ) }
   given!(:answer) { create(:answer, question: question, user: another_user ) }

   scenario 'Guest tries to set best answer' do
     visit question_path(question)

     expect(page).to_not have_link 'Set best'
   end

   scenario 'Non-author tries to choose best answer' do
     sign_in(another_user)
     visit question_path(question)

     expect(page).to_not have_link 'Set best'
   end

   describe 'Author of the question' do
     before do
       sign_in(question.user)
       visit question_path(question)
     end

     scenario 'Sees choose best link' do
       within ".answer_#{answer.id}" do
         expect(page).to have_link 'Set best'
       end
     end

     scenario 'Sets answer as best and displays first', js: true do
       within ".answer_#{answer.reload.id}" do
         click_on 'Set best'
         expect(page).to_not have_link 'Set best'
         expect(page).to have_css('svg.octicon-check', count: 1)
       end

       within ".answers" do
         expect(answer.body).to appear_before(first_answer.body)
       end
     end

     scenario 'Sets new answer as best', js: true do
       within ".answer_#{answer.reload.id}" do
         click_on 'Set best'
         expect(page).to_not have_link 'Set best'
         expect(page).to have_css('svg.octicon-check', count: 1)
       end

       within ".answer_#{previous_best_answer.reload.id}" do
         expect(page).to have_link 'Set best'
         expect(page).to_not have_css('svg.octicon-check', count: 1)
       end
     end
   end
end
