class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @last_day_questions = Question.where("created_at > ?", Time.now - 1.day)

    mail to: user.email
  end
end
