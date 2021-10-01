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
    describe 'edits his answer', js: true do
      before do
        login user
        visit question_path(question)
      end

      describe 'manipulating files' do
        before do
          within '.answers' do
            click_on 'Edit', id: "answer-edit-#{answer.id}"
            attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

            fill_in 'answer[title]', with: 'edited answer'
            click_on 'Save'
          end
        end

        scenario 'adds files while edits his answer' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end

        scenario 'deletes added files' do
          sleep(1)
          within "#file-#{answer.files.first.id}" do
            click_on 'Delete'
          end

          expect(page).not_to have_link 'rails_helper.rb'
        end
      end

      scenario 'edits his answer' do
        within '.answers' do
          click_on 'Edit', id: "answer-edit-#{answer.id}"

          fill_in 'answer[title]', with: 'edited answer'
          click_on 'Save'
        end

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
