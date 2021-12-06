# frozen_string_literal: true

require 'rails_helper'

feature 'User subscribes to the question' do
  let(:user)     { create :user }
  let(:question) { create :question }

  before do
    login user
    visit question_path(question)
  end

  it 'can subscribe', js: true do
    click_on 'Subscribe'

    expect(page).to have_content 'You have successfully subscribed to question updates'
  end

  it 'can unsubscribe', js: true do
    click_on 'Subscribe'
    click_on 'Unsubscribe'

    expect(page).to have_content 'You have successfully unsubscribed'
  end
end
