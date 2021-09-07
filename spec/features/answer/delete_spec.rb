# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answes' do
  describe 'User can delete its own question' do
    scenario 'finds own answer and delete it from list of all answers of a question' do
      user     = create :user
      question = create :question, user: user
      answer   = create :answer, question: question, user: user

      login user
      visit questions_path

      click_link(question.title)

      within("#answer-delete-#{answer.id}") { click_on 'Delete' }

      expect(page).to have_content 'Answer successfully deleted!'
    end
  end
end
