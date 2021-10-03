# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :title, presence: true

  def mark_as_best
    question.update(best_answer_id: id)
  end

  def best_answer?
    question.best_answer_id == id
  end
end
