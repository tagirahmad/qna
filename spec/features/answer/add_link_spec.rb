# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', '
  In order to provide aditional info to answer
' do
  given(:user) { create :user }
  given(:question) { create :question }
  given(:gist_url) { 'https://gist.github.com/tagirahmad/62598000f63a19949cbfeb39793a3c29' }

  scenario 'User adds link when asks question', js: true do
    login user

    visit question_path(question)

    fill_in 'Answer title', with: 'Test answer title'
    fill_in 'Link name',	with: 'My gist'
    fill_in 'Url',	with: gist_url

    click_on 'Answer to question'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
