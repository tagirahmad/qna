# frozen_string_literal: true

class Notification
  def notify_about_updates(record, belongs_to: nil)
    if belongs_to
      belongs_to.subscribers&.find_each(batch_size: 500) do |subscriber|
        NotificationMailer.notify_about_updates(record, subscriber).deliver_later
      end
    else
      record&.subscribers&.find_each(batch_size: 500) do |subscriber|
        NotificationMailer.notify_about_updates(record, subscriber).deliver_later
      end
    end
  end
end
