# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one_attached :file

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  validates :title, :body, presence: true
end
