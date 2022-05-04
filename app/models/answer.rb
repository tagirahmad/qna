# frozen_string_literal: true

class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  belongs_to :question, touch: true
  belongs_to :user

  accepts_nested_attributes_for :links,    reject_if: :all_blank
  accepts_nested_attributes_for :comments, reject_if: :all_blank

  validates :title, presence: true

  after_create :notify_subscribers, if: :any_subscribers?

  def mark_as_best
    transaction do
      question.update(best_answer_id: id)
      question.reward&.update(user: user)
    end
  end

  def best_answer?
    question.best_answer_id == id
  end

  private

  def notify_subscribers
    NotificationJob.perform_later(self, question)
  end

  def any_subscribers?
    question.subscriptions.exists?
  end
end
