class Link < ApplicationRecord
  # has_many :questions, dependent: :destroy
  # has_many :answers, dependent: :destroy

  belongs_to :linkable, polymorphic: true
  
  validates :name, :url, presence: true
end
