# frozen_string_literal: true

require 'rails_helper'

describe 'User can add links to question', '
  In order to provide aditional info to question
' do
  let(:user)        { create :user }
  let(:second_user) { create :user }
  let(:gist_url)    { 'https://gist.github.com/tagirahmad/62598000f63a19949cbfeb39793a3c29' }
  let(:gist_url2)   { 'https://google.com' }
  let(:question)    { create :question, user: user }

  context 'Owner' do
    before { login user }

    it 'User adds links when asks question', js: true do
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

    it 'User-owner adds links when edits question', js: true do
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

  it 'User non-owner can not add links' do
    login second_user

    visit question_path question

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end
end
