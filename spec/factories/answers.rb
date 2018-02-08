FactoryBot.define do
  factory :answer do
    body "MyString"
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
