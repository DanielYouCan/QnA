FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body "MyString"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
