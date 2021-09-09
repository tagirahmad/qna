# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "My title #{n}" }
    user
    body { 'MyText' }
  end

  trait :invalid do
    title { nil }
  end
end
