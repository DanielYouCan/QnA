module AnswersHelper
  def show_set_best?(user, answer)
    user&.author_of?(answer.question) && !answer.best?
  end
end
