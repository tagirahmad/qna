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

  trait :with_file do
    after :create do |answer|
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end
  end
end
