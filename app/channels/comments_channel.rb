class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question:#{data['question_id'].to_i}:comments"
  end

  def unfollow
    stop_all_streams
  end
end
