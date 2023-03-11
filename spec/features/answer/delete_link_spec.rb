# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete links from answer' do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:question)    { create(:question, user:) }
  let(:answer)      { create(:answer, user:, question:) }
  let!(:link)       { create(:link, linkable: answer) }

  describe 'Owner' do
    it 'deletes links from answer', js: true do
      login user
      visit question_path question

      within('.answers .links') { click_on 'Delete' }

      expect(page).not_to have_link link.name, href: link.url
    end
  end

  describe 'Non-owner' do
    it 'can not delete link' do
      login second_user
      visit question_path question

      within(all('.answers .links').first) { expect(page).not_to have_link 'Delete' }
    end
  end
end
