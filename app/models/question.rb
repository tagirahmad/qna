# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable
  include Subscribeable
  include Linkable

  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  has_many_attached :files

  accepts_nested_attributes_for :links,  reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  belongs_to :best_answer, class_name: 'Answer', optional: true
  belongs_to :user

  validates :title, :body, presence: true

  after_create :create_subscription

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def find_user_subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def create_subscription
    subscriptions.create(user_id: user_id)
  end
end
