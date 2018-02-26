FactoryBot.define do
  factory :comment do
    body "CommentText"
    user
  end

  factory :invalid_comment, class: "Comment" do
    body nil
    user
  end
end
