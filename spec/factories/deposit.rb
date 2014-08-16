FactoryGirl.define do
  factory :deposit do
    association :project
    txid "txid"
    confirmations 1
    amount 100
  end
end
