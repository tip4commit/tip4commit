FactoryGirl.define do
  factory :tip do
    association :user
    association :project
    amount 1
  end
end
