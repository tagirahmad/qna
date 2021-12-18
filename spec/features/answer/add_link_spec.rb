# frozen_string_literal: true

require 'rails_helper'

describe 'User can add links to answer', '
  In order to provide aditional info to answer
' do
  let(:user) { create :user }
  let(:second_user) { create :user }
  let(:question)	{ create :question }
  let!(:answer) { create :answer, question: question, user: user }
  let(:gist_url)	{ 'https://gist.github.com/tagirahmad/62598000f63a19949cbfeb39793a3c29' }
  let(:gist_url2)   { 'https://google.com' }
  let(:invalid_url) { 'google' }

  context 'Owner' do
    before { login user }

    it 'User adds valid link when asks question', js: true do
      visit question_path question

      fill_in 'Answer title', with: 'Test answer title'
      fill_in 'Link name',	  with: 'My gist'
      fill_in 'Url',	        with: gist_url

      click_on 'Add a link'

      within(all('.nested-fields')[1]) do
        fill_in 'Link name',	with: 'My gist2'
        fill_in 'Url', with: gist_url2
      end

      click_on 'Answer to question'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist2', href: gist_url2
      end
    end

    it 'User adds invalid link when asks question', js: true do
      visit question_path question

      fill_in 'Answer title', with: 'Test answer title'
      fill_in 'Link name',	with: 'Invalid url'
      fill_in 'Url',	with: invalid_url

      click_on 'Answer to question'

      expect(page).to have_content 'Links url please enter in correct format'
    end
  end

  context 'Non-owner' do
    it 'User non-owner can not add links' do
      login second_user

      visit question_path question

      within '.answers' do
        expect(page).to have_content answer.title
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
