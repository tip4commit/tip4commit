# frozen_string_literal: true

FactoryBot.define do
  factory :sendmany do
    txid { 'txid' }
    data { 'MyText' }
    result { 'MyString' }
    is_error { false }
  end
end
