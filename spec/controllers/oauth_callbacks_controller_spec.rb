# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/NamedSubject
RSpec.describe OauthCallbacksController, type: :controller do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => '123' } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      allow(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'when user exists' do
      let(:user) { create :user }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'logins user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when user does not exists' do
      before do
        allow(User).to receive :find_for_oauth
        get :github
      end

      it 'redirects to root path if user does not exists' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user if it does not exists' do
        expect(subject.current_user).to be_nil
      end
    end
  end
end
