# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files
  has_one :reward, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  validates :title, :body, presence: true
end
