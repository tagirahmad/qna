# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign up', "
  In order to ask questions
" do
  before { visit new_user_registration_path }

  describe 'successfull registration' do
    before do
      fill_in 'Email',                 with: 'test@gmail.com'
      fill_in 'Password',	             with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Register'
    end

    it 'redirects to root path' do
      expect(page).to have_current_path(root_path)
    end

    it 'has welcome message' do
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end
  end

  describe 'registration failed' do
    let(:user) { create :user, email: 'test@gmail.com' }

    before { fill_in 'Email', with: user.email }

    it 'with incorrect password' do
      fill_in 'Password',	             with: '12345'
      fill_in 'Password confirmation', with: '12345'
      click_on 'Register'

      expect(page).to have_content 'Password is too short'
    end

    it 'with email already exists' do
      # save_and_open_page
      fill_in 'Password',	             with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_on 'Register'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end
