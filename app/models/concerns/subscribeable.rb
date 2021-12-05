# frozen_string_literal: true

module Subscribeable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy, as: :subscribeable
  end
end
