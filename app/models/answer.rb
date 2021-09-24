# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :title, presence: true

  def mark_as_best
    question.update(best_answer_id: id)
  end
end
