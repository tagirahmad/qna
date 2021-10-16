# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete links from answer' do
 	given(:user)        { create :user }
  given(:second_user) { create :user  }
  given(:question)    { create :question, user: user  }
  given(:answer)      { create :answer, user: user, question: question  }
  given!(:link)       { create :link, linkable: answer }

  context 'Owner' do
    scenario 'User deletes links from answer', js: true do
      login user

      visit question_path question

      within '.answers .links' do
        click_on 'Delete'
      end

      expect(page).not_to have_link link.name, href: link.url
    end
  end

  context 'Non-owner' do
    scenario 'Can not delete link' do
      login second_user

      visit question_path question

      within(all('.answers .links').first) do
        expect(page).not_to have_link 'Delete'
      end
    end
  end
end
