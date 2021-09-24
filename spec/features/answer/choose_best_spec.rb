# frozen_string_literal: true

require 'rails_helper'

feature 'User can choose best answer' do
  given(:user)           { create :user }
  given(:second_user)    { create :user }
  given(:question)       { create :question, user: user }
  given!(:answer)        { create :answer, title: 'first answer', question: question, user: second_user }
  given!(:second_answer) { create :answer, title: 'second answer', question: question, user: user }

  describe 'Authenticated user' do
    describe 'only author can choose best answer' do
      before do
        login user
        visit question_path(question)
      end

      it 'page has Mark best button' do
        expect(page).to have_link 'Mark as best'
      end

      it 'chooses best answer', js: true do
        within("#answer-#{answer.id}") do
          click_on 'Mark as best'
          expect(page).to have_content 'It is the best answer!'
        end
      end
    end

    scenario 'not an author can not choose best answer' do
      login second_user
      visit question_path(question)

      expect(page).not_to have_link 'Mark as best'
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can not choose best answer' do
      visit question_path(question)

      expect(page).not_to have_link 'Mark as best'
    end
  end

  scenario 'Best answer should be the first in the list', js: true do
    login user

    visit question_path(question)

    expect(page).to have_content answer.title
    expect(page).to have_content second_answer.title
    
    within("#answer-#{second_answer.id}") { click_on 'Mark as best' }
    
    sleep(1)

    expect(first(".answers .answer").text).to have_content 'It is the best answer!'
  end
end
