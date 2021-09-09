# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    title { 'MyAnswer' }
    user
    question
  end

  trait :invalid_answer do
    title { nil }
  end
end
