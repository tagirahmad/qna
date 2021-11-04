class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :user, :body, presence: true

  validates :commentable_type, inclusion: { in: %w[Question Answer] }
end
