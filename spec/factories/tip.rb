FactoryGirl.define do
  factory :tip do
    association :user
    association :project
    amount 1
    commit { Digest::SHA1.hexdigest(SecureRandom.hex) }

    factory :undecided_tip do
      amount nil
    end
  end
end
