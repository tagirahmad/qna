# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: %i[votable_type votable_id], message: { json: 'You have already voted' } }
  validates :votable_type, inclusion: { in: %w[Question Answer] }

  def not_votable_author?
    votable&.user&.author_of?(self)
  end
end
