# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  describe 'With devise' do
    let(:user) { create :user }

    before { visit new_user_session_path }

    it 'registered user tries to sign in' do
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content 'Signed in successfully'
    end

    it 'unregistered user tries to sign in' do
      fill_in 'Email', with: 'wrong@test.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password'
    end
  end

  describe 'User tries to sign in with social networks' do
    before { visit new_user_session_path }

    describe 'with github' do
      it 'page has sign in link' do
        expect(page).to have_link 'Sign in with GitHub'
      end

      it 'user clicks to sign button' do
        OmniAuth.config.add_mock(:github, { uid: '12345', info: { email: 'test@mail.com' } })
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    describe 'with google' do
      it 'page has sign in link' do
        expect(page).to have_link 'Sign in with Google'
      end

      it 'user clicks to sign button' do
        OmniAuth.config.add_mock(:google_oauth2, { uid: '12345', info: { email: 'test2@mail.com' } })
        click_on 'Sign in with Google'

        expect(page).to have_content 'Successfully authenticated from Google account.'
      end
    end
  end
end
