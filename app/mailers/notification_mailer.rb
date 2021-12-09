# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def notify_about_updates(record, user)
    @record = record

    mail to: user.email, subject: "New #{@record.class.to_s.downcase} is appeared!"
  end
end
