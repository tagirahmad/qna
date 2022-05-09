# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete questions' do
  let(:user)            { create :user }
  let(:second_user)     { create :user }
  let!(:question) { create :question, user: user }

  context 'when deletes its own question' do
    before do
      login user
      visit questions_path
      click_link question.title
    end

    it "question's title is on the page before deletion" do
      expect(page).to have_content question.title
    end

    it 'delete question button pressed', js: true do
      click_on 'Delete', id: 'question-delete'
      expect(page).to have_content('Question successfully deleted!')
        .and have_current_path(questions_path, ignore_query: true)
        .and have_no_content(question.title).and have_no_content question.body
    end
  end

  it "can't delete a question that is not its own" do
    login second_user

    visit questions_path

    click_link(question.title)

    expect(page).not_to have_css '#question-delete', text: 'Delete'
  end

  it "unauthorised user can't delete a question" do
    visit questions_path

    click_link(question.title)

    expect(page).not_to have_css '#question-delete', text: 'Delete'
  end
end
