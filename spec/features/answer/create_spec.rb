# frozen_string_literal: true

require 'rails_helper'

feature 'User can add answer to particular question', "
  In order to users can look at useful answers
" do
  given!(:user)     { create :user }
  given!(:question) { create :question, user: user }

  describe 'Authenticated user', js: true do
    background do
      login user

      visit question_path(question)
    end

    describe 'makes valid an answer' do
      background do
        fill_in 'Answer title', with: 'Test answer title'
        click_on 'Answer to question'
      end

      scenario 'shows answer title on the page' do
        expect(page).to have_content 'Test answer title'
      end

      # scenario 'shows message that answer is created' do
      #   expect(page).to have_content 'The answer was created successfully.'
      # end
    end

    scenario 'makes an answer with errors', js: true do
      click_on 'Answer to question'

      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Unauthenticated user makes an answer', js: true do
    scenario 'can not add an answer' do
      visit question_path(question)

      fill_in 'Answer title', with: 'Test answer title'
      click_on 'Answer to question'

      expect(page).not_to have_content 'Test answer title'
      # expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
