FactoryGirl.define do
  factory :deposit do
    association :project
    txid "txid"
    confirmations 1
    paid_out 1
    paid_out_at "2013-10-19 23:01:22"
    amount 100
  end
end
