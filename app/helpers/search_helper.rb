module SearchHelper
  def search_options
    Search::SEARCH_OPTIONS.map { |option| [option, option] }
  end

  def results_handler(result)
    type = result.class.name

    case type
    when "User"
      tag.b("User:") + result.username
    when "Question"
      tag.div((link_to result.title, question_path(result)) + tag.br + result.body.truncate(40))
    else
      tag.b(type) + tag.br + result.body.truncate(40)
    end
  end

end
