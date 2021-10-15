# frozen_string_literal: true

class Answer < ApplicationRecord
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  belongs_to :question
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, presence: true

  def mark_as_best
    question.update(best_answer_id: id)
    question.reward&.update(user: user)
  end

  def best_answer?
    question.best_answer_id == id
  end
end
