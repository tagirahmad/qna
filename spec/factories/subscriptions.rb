# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    user { nil }
    subscribeable { nil }
  end
end
