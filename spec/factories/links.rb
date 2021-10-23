# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    name { 'My link' }
    url  { 'https://www.google.com/' }
  end
end
