# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to question', '
  In order to provide aditional info to question
' do
  given(:user)        { create :user }
  given(:second_user) { create :user }
  given(:gist_url)    { 'https://gist.github.com/tagirahmad/62598000f63a19949cbfeb39793a3c29' }
  given(:gist_url2)   { 'https://google.com' }
  given(:question)    { create :question, user: user }

  context 'Owner' do
    before { login user }

    scenario 'User adds links when asks question', js: true do
      visit new_question_path

      fill_in 'Title',	with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name',	with: 'My gist'
      fill_in 'Url',	      with: gist_url

      click_on 'Add a link'

      within(all('.nested-fields')[1]) do
        fill_in 'Link name',	with: 'My gist2'
        fill_in 'Url',	      with: gist_url2
      end

      click_on 'Ask'

      expect(page).to have_link 'My gist',  href: gist_url
      expect(page).to have_link 'My gist2', href: gist_url2
    end

    scenario 'User-owner adds links when edits question', js: true do
      visit question_path question

      within '.question' do
        click_on 'Edit'
        click_on 'Add a link'

        fill_in 'Link name',	with: 'My gist'
        fill_in 'Url',	      with: gist_url

        click_on 'Save'

        expect(page).to have_link 'My gist', href: gist_url
      end
    end
  end

  scenario 'User non-owner can not add links' do
    login second_user

    visit question_path question

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
