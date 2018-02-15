module AnswersHelper
  def show_choose_best?(user, answer)
    user&.author_of?(answer.question) && answer.not_best?
  end
end
