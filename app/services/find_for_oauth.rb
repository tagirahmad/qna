# frozen_string_literal: true

class FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    find_or_create_user_with_authorization
  end

  private

  def find_or_create_user_with_authorization
    email = auth.info[:email]
    password = Devise.friendly_token[0, 20]
    user = User.find_by(email: email)

    user ||= User.create!(email: email, password: password, password_confirmation: password)

    user.create_authorization(auth)

    user
  end
end
