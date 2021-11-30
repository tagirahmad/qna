# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "My title #{n}" }
    association :user, factory: :user
    body { 'MyText' }

    trait :invalid do
      title { nil }
    end

    trait :updated do
      title { 'My updated title' }
      body  { 'My updated body' }
    end

    trait :with_file do
      after :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      end
    end
  end
end
