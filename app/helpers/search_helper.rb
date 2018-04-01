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

  def search_cache(object, body, results)
    size = results.size
    max_updated_at = results.max_by(&:updated_at).updated_at.try(:utc).try(:to_s)
    "#{object}/#{body}-#{size}-#{max_updated_at}"
  end

end
