# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create :user }
  given!(:second_user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question, user: user }

  scenario 'Unathenticated user can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      login user

      visit question_path(question)

      within '.answers' do
        click_on 'Edit', id: "answer-edit-#{answer.id}"

        fill_in 'answer[title]', with: 'edited answer'
        click_on 'Save'

        # wait_for_ajax

        expect(page).not_to have_content answer.title
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      login user

      visit question_path(question)

      within '.answers' do
        click_on 'Edit', id: "answer-edit-#{answer.id}"

        fill_in 'answer[title]', with: ''
        click_on 'Save'
      end

      expect(page).to have_content answer.title
      expect(page).to have_content "Title can't be blank"
      expect { answer }.not_to change(answer, :title)
    end

    scenario "tries to edit other user's answer" do
      login second_user

      visit question_path(question)

      expect(page).not_to have_link 'Edit', class: "answer-edit-#{answer.id}"
    end
  end
end
