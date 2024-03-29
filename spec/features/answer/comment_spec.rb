# frozen_string_literal: true

require 'rails_helper'

describe 'User can add a comment to answer' do
  let(:user)      { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question:) }

  describe 'Authenticated user' do
    before do
      login user
      visit question_path question
    end

    describe 'adds a comment', js: true do
      before do
        within '.answers' do
          click_on 'Add a comment'
        end
      end

      it 'with valid attributes' do
        within ".answers #comment-answer-#{answer.id}" do
          fill_in 'Comment body', with: 'My super comment'
          click_on 'Save'
        end
        expect(page).to have_content('The comment was created successfully.').and have_content 'My super comment'
      end

      it 'with invalid attributes' do
        within "#comment-answer-#{answer.id}" do
          fill_in 'Comment body', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  it 'Unauthenticated', js: true do
    visit question_path question

    within '.answers' do
      click_on 'Add a comment'
    end

    within "#comment-answer-#{answer.id}" do
      fill_in 'Comment body', with: ''
      click_on 'Save'
    end

    expect(page).not_to have_link 'You need to sign in or sign up before continuing.'
  end

  describe 'Multiple sessions', js: true do
    it 'comment appears on another user\'s page', js: true do
      using_session 'user' do
        login user
        visit question_path question
        within '.answers' do
          click_on 'Add a comment'
        end
      end

      using_session 'guest' do
        visit question_path question
      end

      using_session 'user' do
        within ".answers #comment-answer-#{answer.id}" do
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
