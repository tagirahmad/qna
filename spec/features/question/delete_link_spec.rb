# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete links from question' do
  let(:user) { create :user }
  let(:second_user) { create :user }
  let(:question)    { create :question, user: user }
  let!(:link)       { create :link, linkable: question }

  describe 'owner' do
    it 'user deletes links when edit question', js: true do
      login user
      visit question_path question
      within('.question .links') { click_on 'Delete' }

      expect(page).not_to have_link link.name, href: link.url
    end
  end

  describe 'non-owner' do
    it 'can not delete link' do
      login second_user
      visit question_path question

      within '.question .links' do
        expect(page).not_to have_link 'Delete'
      end
    end
  end
end
