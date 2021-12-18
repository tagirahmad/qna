# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete questions' do
  let(:user)        { create :user }
  let(:second_user) { create :user }
  let!(:question)   { create :question, user: user }

  it 'User can delete its own question', js: true do
    login user

    visit questions_path

    click_link(question.title)

    expect(page).to have_content question.title
    click_on 'Delete', id: 'question-delete'

    expect(page).to have_content 'Question successfully deleted!'
    expect(page).to have_current_path questions_path, ignore_query: true
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
  end

  it "User can't delete a question that is not its own" do
    login second_user

    visit questions_path

    click_link(question.title)

    expect(page).not_to have_css '#question-delete', text: 'Delete'
  end

  it "Unathorised user can't delete a question" do
    visit questions_path

    click_link(question.title)

    expect(page).not_to have_css '#question-delete', text: 'Delete'
  end
end
