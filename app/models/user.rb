# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :questions
  has_many :answers
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(entity)
    entity.user_id == id
  end
end
