# frozen_string_literal: true

require 'rails_helper'

feature 'User can add a comment to answer' do
  given(:user)      { create :user }
  given!(:question) { create :question }

  describe 'Authenticated user' do
    before do
      login user
      visit question_path question
    end

    describe 'adds a comment', js: true do
      before { click_on 'Add a comment' }

      scenario 'with valid attributes' do
        within ".question #comment-question-#{question.id}" do
          fill_in 'Comment body', with: 'My super comment'
          click_on 'Save'
        end
        expect(page).to have_content 'The comment was created successfully.'
        expect(page).to have_content 'My super comment'
      end

      scenario 'with invalid attributes' do
        within "#comment-question-#{question.id}" do
          fill_in 'Comment body', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated', js: true do
    visit question_path question

    click_on 'Add a comment'

    within "#comment-question-#{question.id}" do
      fill_in 'Comment body', with: ''
      click_on 'Save'
    end

    expect(page).not_to have_link 'You need to sign in or sign up before continuing.'
  end

  context 'multiple sessions', js: true do
    scenario 'comment appears on another user\'s page', js: true do
      using_session 'user' do
        login user
        visit question_path question
        click_on 'Add a comment'
      end

      using_session 'guest' do
        visit question_path question
      end

      using_session 'user' do
        within ".question #comment-question-#{question.id}" do
          fill_in 'Comment body', with: 'My super comment'
          click_on 'Save'
        end

        expect(page).to have_content 'My super comment'
      end

      using_session 'guest' do
        expect(page).to have_content 'My super comment'
      end
    end
  end
end

