# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question' do
  given!(:user) { create :user }
  given!(:second_user) { create :user }
  given!(:question) { create :question, user: user }

  scenario 'Unathenticated user can not edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      login user

      visit question_path(question)

      click_on 'Edit', class: 'edit-question'
      fill_in 'question[title]', with: 'my edited question'
      fill_in 'question[body]',  with: 'my edited question body'
      click_on 'Save'

      expect(page).not_to have_content question.title
      expect(page).not_to have_content question.body
      expect(page).to have_content 'my edited question'
      expect(page).to have_content 'my edited question body'
      expect(page).not_to have_selector 'textarea'
    end

    scenario 'edits his question with errors', js: true do
      login user

      visit question_path(question)

      click_on 'Edit', class: 'edit-question'
      fill_in 'question[title]', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect { question }.not_to change(question, :title)
    end

    scenario "tries to edit other user's answer" do
      login second_user

      visit question_path(question)

      expect(page).not_to have_link 'Edit', class: 'edit-question'
    end
  end
end
