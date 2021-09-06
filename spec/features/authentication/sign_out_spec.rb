# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out' do
  given(:user) { create :user }
  background { login user }

  scenario 'log out' do
    click_on 'Log out'
    # save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
  end
end
