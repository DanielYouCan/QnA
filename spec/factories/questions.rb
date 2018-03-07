FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body "MyText"
    user
  end

  factory :question_with_votes, class: "Question" do
    title
    body "MyText"
    user

    after(:build) do |question|
      question.votes << create(:vote, votable: question)
    end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
