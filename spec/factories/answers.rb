FactoryBot.define do
  sequence :body do |n|
    "MyString#{n}"
  end
  
  factory :answer do
    body
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
