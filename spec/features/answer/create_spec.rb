# frozen_string_literal: true

require 'rails_helper'

feature 'User can add answer to particular question', "
  In order to users can look at useful answers
" do
  given!(:user) { create :user }
  given!(:question) { create :question, user: user }
  # given!(:answer) { create :answer, question_id: question.id, user_id: user }

  describe 'Authenticated user' do
    background do
      login user

      visit question_path(question)
    end

    scenario 'makes an answer' do
      fill_in 'Answer title',  with: 'Test answer title'
      click_on 'Answer to question'

      expect(page).to have_content 'Test answer title'
      expect(page).to have_content 'The answer was created successfully.'
    end

    describe 'makes valid an answer' do
      background do
        fill_in 'Answer title', with: 'Test answer title'
        click_on 'Answer to question'
      end

      scenario 'shows answer title on the page' do
        expect(page).to have_content 'Test answer title'
      end

      scenario 'shows message that answer is created' do
        expect(page).to have_content 'The answer was created successfully.'
      end
    end

    scenario 'makes an answer with errors' do
      click_on 'Answer to question'

      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Unauthenticated user makes an answer' do
    background do
      visit question_path(question)

      fill_in 'Answer title', with: 'Test answer title'
      click_on 'Answer to question'
    end

    scenario 'and view shows that there is no any answers' do
      expect(page).not_to have_content  'Test answer title'
    end

    scenario 'tells to user that you need to sign in' do
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
