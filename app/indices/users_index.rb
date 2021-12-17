# frozen_string_literal: true

ThinkingSphinx::Index.define :user, with: :active_record do
  # fields
  indexes email

  # attributes
  has created_at
end
