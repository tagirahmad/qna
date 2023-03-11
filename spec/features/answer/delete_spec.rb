# frozen_string_literal: true

require 'rails_helper'

describe 'User can delete answers' do
  let(:user)        { create(:user) }
  let(:second_user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question:, user:) }

  it 'User can delete only his answers', js: true do
    login user
    visit questions_path

    click_link question.title

    expect(page).to have_content answer.title

    within("#answer-delete-#{answer.id}") { click_on 'Delete' }

    expect(page).not_to have_content answer.title
    expect(page).to have_content 'Answer successfully deleted!'
  end

  it 'User can not delete not its own answer' do
    login second_user
    visit questions_path

    click_link question.title

    expect(page).to have_content answer.title
    expect(page).not_to have_css "#answer-delete-#{answer.id}", text: 'Delete'
  end

  it 'Unathenticated can not delete not its own answer' do
    visit questions_path

    click_link question.title

    expect(page).to have_content answer.title
    expect(page).not_to have_css "#answer-delete-#{answer.id}", text: 'Delete'
  end
end
