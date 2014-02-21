FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@gmail.com" }
    password "password"
    login_token "login_token"
    name 'kd'
    nickname 'kd'
  end
end
