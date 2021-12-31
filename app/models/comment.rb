# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :user, :body, presence: true

  validates :commentable_type, inclusion: { in: %w[Question Answer] }
end
