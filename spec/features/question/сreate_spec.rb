# frozen_string_literal: true

require 'rails_helper'

describe 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  let(:user) { create :user }
  let(:prefill_in_title_and_body) do
    fill_in 'Title', with: 'Test question title'
    fill_in 'Body',  with: 'Test question body'
  end

  describe 'Authenticated user' do
    before do
      login user
      visit questions_path
      click_on 'Ask question'
    end

    context 'when valid attrs' do
      before { prefill_in_title_and_body }

      it 'asks a question' do
        click_on 'Ask'

        ['Your question was successfully created.', 'Test question title',
         'Test question body'].each { expect(page).to have_content _1 }
      end

      it 'asks a question with attached files' do
        attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Ask'

        %w[rails_helper.rb spec_helper.rb].each { expect(page).to have_link _1 }
      end

      it 'asks a question with links' do
        fill_in 'Link name', with: 'https://google.com'
        fill_in 'Url',       with: 'https://google.com'
        click_on 'Ask'

        expect(page).to have_link 'https://google.com'
      end
    end

    it 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end
  end

  describe 'Multiple sessions' do
    it 'question appears on another user\'s page', js: true do
      title_and_body = ['Test question title', 'Test question body']

      using_session 'user' do
        login user
        visit questions_path
        click_on 'Ask question'
      end

      using_session 'guest' do
        visit questions_path
      end

      using_session 'user' do
        prefill_in_title_and_body
        click_on 'Ask'

        title_and_body.each { expect(page).to have_content _1 }
      end

      using_session 'guest' do
        expect(page).to have_content title_and_body.first
      end
    end
  end

  it 'unauthenticated user can not ask for a question' do
    visit questions_path
    expect(page).not_to have_content 'Ask question'
  end
end
