FactoryBot.define do
  factory :answer do
    title { 'MyAnswer' }
  end

  trait :invalid_answer do
    title { nil }
  end
end
