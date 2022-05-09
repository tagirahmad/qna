# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindForOauth do
  subject(:service) { described_class.new(auth) }

  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  let!(:user) { create :user }

  context 'when user already has authorization' do
    it 'return the user' do
      user.authorizations.create(provider: 'facebook', uid: '123456')

      expect(service.call).to eq user
    end
  end

  context 'when user has not authorization' do
    let(:user_for_oauth) { service.call }

    context 'when user already exists' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

      it 'does not create new user' do
        expect { user_for_oauth }.not_to change User, :count
      end

      it 'creates authorization for user' do
        expect { user_for_oauth }.to change(user.authorizations, :count).by 1
      end

      it 'creates authorization with provider and uid' do
        authorization = user_for_oauth.authorizations.first
        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end

      it 'returns the user' do
        expect(user_for_oauth).to eq user
      end
    end

    context 'when user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'email@gmail.com' }) }

      it 'creates new user' do
        expect { user_for_oauth }.to change(User, :count).by 1
      end

      it 'creates new user with appropriate attributes' do
        expect(user_for_oauth).to be_a(User).and have_attributes(email: auth.info.email)
      end

      it 'creates authorization for user' do
        expect(user_for_oauth.authorizations).not_to be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = user_for_oauth.authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end
end
