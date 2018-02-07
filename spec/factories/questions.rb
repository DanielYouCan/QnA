FactoryBot.define do
  factory :question do
    title "MyString"
    body "MyString"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
