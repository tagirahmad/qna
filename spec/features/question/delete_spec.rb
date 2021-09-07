# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete questions' do
  describe 'User can delete its own question' do
    given(:user)      { create :user }
    given!(:question) { create :question, user: user }

    scenario 'finds own question and delete it from list of all questions' do
      login user

      visit questions_path
      click_link(question.title)

      within('#question-delete') { click_on 'Delete' }

      expect(page).to have_content 'Question successfully deleted!'
    end
  end

  describe "User can't delete a question that is not its own" do
    given!(:question) { create :question, user: create(:user) }

    scenario 'finds question and tries to delete it' do
      visit questions_path
      click_link(question.title)

      expect(page).not_to have_content 'Question successfully deleted!'
    end
  end
end
