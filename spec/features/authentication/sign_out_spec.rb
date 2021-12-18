# frozen_string_literal: true

require 'rails_helper'

describe 'User can sign out' do
  let(:user) { create :user }

  before { login user }

  it 'log out' do
    click_on 'Log out'
    # save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
  end
end
