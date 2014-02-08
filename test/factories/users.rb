FactoryGirl.define do
  factory :user do
    email "john@doge.com"
    password "password"
    login_token "login_token"
  end
end
