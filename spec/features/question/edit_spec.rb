# frozen_string_literal: true

require 'rails_helper'

describe 'User can edit his question' do
  let!(:user)        { create(:user) }
  let!(:second_user) { create(:user) }
  let!(:question)    { create(:question, :with_file, user:) }
  let!(:link)        { create(:link, linkable: question) }

  it 'unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'edits his question', js: true do
      before do
        login user
        visit question_path(question)
      end

      context 'when edits its own question' do
        before do
          click_on 'Edit', class: 'edit-question'
          fill_in 'question[title]', with: 'my edited question'
          fill_in 'question[body]',  with: 'my edited question body'
          click_on 'Save'
        end

        it 'there are no previous title and body' do
          [question.title, question.body].each { expect(page).not_to have_content _1 }
          expect(page).not_to have_selector 'textarea'
        end

        it 'shows new edited data' do
          expect(page).to have_content('my edited question').and have_content 'my edited question body'
        end
      end

      describe 'edits links' do
        it 'press Edit to change url name', js: true do
          click_on 'Edit', class: 'edit-question'
          within '.question' do
            fill_in 'Link name', with: 'link changed'
            click_on 'Save'
          end
          sleep(1)
          expect(page).to have_link 'link changed', href: link.url
        end
      end

      it 'adds files while edits his question' do
        click_on 'Edit', class: 'edit-question'
        within "#edit-question-#{question.id}" do
          attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
          click_on 'Save'
        end

        %w[rails_helper.rb spec_helper.rb].each { expect(page).to have_link _1 }
      end

      it 'deletes added files' do
        within "#file-#{question.files.first.id}" do
          click_on 'Delete'
        end

        expect(page).not_to have_link 'rails_helper.rb'
      end
    end

    it 'edits his question with errors', js: true do
      login user
      visit question_path(question)

      click_on 'Edit', class: 'edit-question'
      fill_in 'question[title]', with: ''
      click_on 'Save'

      expect(page).to have_content "Title can't be blank"
      expect { question }.not_to change(question, :title)
    end

    it "tries to edit other user's answer" do
      login second_user
      visit question_path(question)

      expect(page).not_to have_link 'Edit', class: 'edit-question'
    end
  end
end
