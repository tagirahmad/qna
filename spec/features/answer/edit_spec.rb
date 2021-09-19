require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:answer) { create :answer, question: question, user: user }

  scenario 'Unathenticated user can not edit answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      login user

      visit question_path(question)
      
      within '.answers' do
        click_on 'Edit', id: "answer-edit-#{answer.id}"
        
        fill_in 'answer[title]', with: 'edited answer'
        click_on 'Save'

        wait_for_ajax
        
        expect(page).not_to have_content answer.title
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his question with errors' do
    end

    scenario "tries to edit other user's question" do
    end
  end
end
