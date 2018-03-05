FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  sequence :username do |n|
    "username_#{n}"
  end

  factory :user do
    email
    username
    confirmed_at Time.now
    password '1234567'
    password_confirmation '1234567'
  end
end
