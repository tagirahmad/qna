# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscribeable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[subscribeable_type subscribeable_id] }
end
