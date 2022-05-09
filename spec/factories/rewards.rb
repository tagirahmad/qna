# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    user     { nil }
    question { nil }
    name     { 'MyText' }
    image    { Rack::Test::UploadedFile.new('app/assets/images/cup-icon.png') }

    trait :with_image do
      image { Rack::Test::UploadedFile.new('app/assets/images/cup-icon.png') }
    end
  end
end
