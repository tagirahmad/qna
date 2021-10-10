# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links to question' do
 	given(:user)      { create :user }
  given(:question)  { create :question, user: user  }
  given!(:link)     { create :link, linkable: question }

  context 'Owner' do 
    scenario 'User deletes links when edit question', js: true do
      login user
      visit question_path question

      save_and_open_page

      within '.links' do
        click_on 'Delete'
      end

      expect(page).not_to have_link link.name, href: link.url
    end
  end
end

