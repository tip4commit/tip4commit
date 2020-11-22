# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    url { 'MyString' }
    full_name { 'test/test' }
    github_id { '1234567890' }

    trait :github do
      host { 'github' }
    end

    trait :bitbucket do
      host { 'bitbucket' }
    end
  end
end
