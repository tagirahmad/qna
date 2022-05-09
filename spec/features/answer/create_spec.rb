# frozen_string_literal: true

require 'rails_helper'

describe 'User can add answer to particular question', "
  In order to users can look at useful answers
" do
  let!(:user)     { create :user }
  let!(:question) { create :question, user: user }

  describe 'Authenticated user', js: true do
    before do
      login user
      visit question_path(question)
    end

    describe 'makes valid an answer' do
      before do
        fill_in 'Answer title', with: 'Test answer title'
        click_on 'Answer to question'
      end

      it 'shows answer title on the page' do
        expect(page).to have_content 'Test answer title'
      end
    end

    it 'makes an answer with attach files', js: true do
      fill_in 'Answer title', with: 'Test answer title'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer to question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'makes an answer with errors', js: true do
      click_on 'Answer to question'
      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Multiple sessions' do
    it 'answer appears on another user\'s page', js: true do
      using_session 'user' do
        login user
        visit question_path question
      end

      using_session 'guest' do
        visit question_path question
      end

      using_session 'user' do
        fill_in 'Answer title', with: 'Test answer title'
        click_on 'Answer to question'
        expect(page).to have_content 'Test answer title'
      end

      using_session 'guest' do
        expect(page).to have_content 'Test answer title'
      end
    end
  end

  describe 'Unauthenticated user makes an answer', js: true do
    it 'can not add an answer' do
      visit question_path question

      fill_in 'Answer title', with: 'Test answer title'
      click_on 'Answer to question'

      expect(page).not_to have_content 'Test answer title'
    end
  end
end
