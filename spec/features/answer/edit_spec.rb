# frozen_string_literal: true

require 'rails_helper'

describe 'User can edit his answer' do
  let!(:user)        { create :user }
  let!(:second_user) { create :user }
  let!(:question)    { create :question }
  let!(:answer)      { create :answer, question: question, user: user }

  it 'Unauthenticated user can not edit answer' do
    visit question_path question
    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'edits his answer', js: true do
      before do
        create :link, linkable: answer
        login user
        visit question_path question
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

        it 'adds files while edits his answer' do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end

        it 'deletes added files' do
          sleep(1)
          within "#file-#{answer.files.first.id}" do
            click_on 'Delete'
          end

          expect(page).not_to have_link 'rails_helper.rb'
        end
      end

      describe 'edits links' do
        it 'press Edit to change url name', js: true do
          within '.answers' do
            click_on 'Edit'

            fill_in 'Link name', with: 'link changed'
            fill_in 'Url',       with: 'https://facebook.com'

            click_on 'Save'
          end
          sleep(1)
          expect(page).to have_link 'link changed', href: 'https://facebook.com'
        end
      end

      it 'edits his answer' do
        within '.answers' do
          click_on 'Edit', id: "answer-edit-#{answer.id}"

          fill_in 'answer[title]', with: 'edited answer'
          click_on 'Save'
        end

        expect(page).not_to have_content answer.title
        expect(page).not_to have_selector 'textarea'
        expect(page).to have_content 'edited answer'
      end
    end

    it 'edits his answer with errors', js: true do
      login user
      visit question_path question

      within '.answers' do
        click_on 'Edit', id: "answer-edit-#{answer.id}"

        fill_in 'answer[title]', with: ''
        click_on 'Save'
      end

      expect(page).to have_content(answer.title).and have_content "Title can't be blank"
      expect { answer }.not_to change(answer, :title)
    end

    it "tries to edit other user's answer" do
      login second_user
      visit question_path question
      expect(page).not_to have_link 'Edit', class: "answer-edit-#{answer.id}"
    end
  end
end
