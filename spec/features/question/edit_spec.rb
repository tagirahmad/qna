# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question' do
  given!(:user)        { create :user }
  given!(:second_user) { create :user }
  given!(:question)    { create :question, :with_file, user: user }
  given!(:link)        { create :link, linkable: question }

  scenario 'Unathenticated user can not edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'edits his question', js: true do
      before do
        login user
        visit question_path(question)
      end

      scenario 'edits his question', js: true do
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

      describe 'edits links' do
        scenario 'press Edit to change url name', js: true do
          click_on 'Edit', class: 'edit-question'
          within '.question' do
            fill_in 'Link name', with: 'link changed'
            click_on 'Save'
          end
          sleep(1)
          expect(page).to have_link 'link changed', href: link.url
        end
      end

      scenario 'adds files while edits his question' do
        click_on 'Edit', class: 'edit-question'
        within "#edit-question-#{question.id}" do
          attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'deletes added files' do
        within "#file-#{question.files.first.id}" do
          click_on 'Delete'
        end

        expect(page).not_to have_link 'rails_helper.rb'
      end
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
