class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  validates :name, presence: true
  validates :image, presence: true

  has_one_attached :image
end
