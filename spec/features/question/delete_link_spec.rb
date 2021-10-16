# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links from  question' do
 	given(:user)        { create :user }
  given(:second_user) { create :user  }
  given(:question)    { create :question, user: user  }
  given!(:link)       { create :link, linkable: question }

  context 'Owner' do 
    scenario 'User deletes links when edit question', js: true do
      login user

      visit question_path question

      within '.question .links' do
        click_on 'Delete'
      end

      expect(page).not_to have_link link.name, href: link.url
    end
  end

  context 'Non-owner' do
    scenario 'Can not delete link' do
      login second_user

      visit question_path question
      
      within '.question .links' do
        expect(page).not_to have_link 'Delete'
      end
    end
  end
end

