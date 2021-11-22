# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :questions
  has_many :answers
  has_many :authorizations,  dependent: :destroy
  has_many :rewards,         dependent: :destroy
  has_many :votes,           dependent: :destroy
  has_many :comments,        dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def author_of?(entity)
    entity.user_id == id
  end

  def self.find_for_oauth(auth)
    FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
