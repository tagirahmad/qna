# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign out' do
  it 'log out' do
    login create :user
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
