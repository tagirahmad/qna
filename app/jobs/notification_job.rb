# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(record, belongs_to: nil)
    Notification.new.notify_about_updates(record, belongs_to:)
  end
end
