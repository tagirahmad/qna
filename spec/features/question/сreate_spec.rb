# frozen_string_literal: true

require 'rails_helper'

describe 'User can create question', "
  In order to get answer from a community
  As an aunthenticated user
  I'd like to be able to ask the question
" do
  let(:user) { create :user }

  describe 'Authenticated user' do
    before do
      login user

      visit questions_path

      click_on 'Ask question'
    end

    it 'asks a question' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body',  with: 'Test question body'
      click_on 'Ask'

      expect(page).to have_content 'Your question was successfully created.'
      expect(page).to have_content 'Test question title'
      expect(page).to have_content 'Test question body'
    end

    it 'asks a question with attached files' do
      fill_in 'Title', with: 'Test question title'
      fill_in 'Body',  with: 'Test question body'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    it 'asks a question with links' do
      fill_in 'Title',     with: 'Test question title'
      fill_in 'Body',      with: 'Test question body'
      fill_in 'Link name', with: 'https://google.com'
      fill_in 'Url',       with: 'https://google.com'
      click_on 'Ask'

      expect(page).to have_link 'https://google.com'
    end

    it 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'multiple sessions' do
    it 'question appears on another user\'s page', js: true do
      Capybara.using_session 'user' do
        login user
        visit questions_path
        click_on 'Ask question'
      end

      Capybara.using_session 'guest' do
        visit questions_path
      end

      Capybara.using_session 'user' do
        fill_in 'Title', with: 'Test question title'
        fill_in 'Body',  with: 'Test question body'
        click_on 'Ask'

        expect(page).to have_content 'Test question title'
        expect(page).to have_content 'Test question body'
      end

      Capybara.using_session 'guest' do
        expect(page).to have_content 'Test question title'
      end
    end
  end

  it 'Unauthenticated user asks a question' do
    visit questions_path

    expect(page).not_to have_content 'Ask question'
  end
end
