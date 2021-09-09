# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete questions' do
  given(:user)        { create :user }
  given(:second_user) { create :user }
  given!(:question)   { create :question, user: user }

  scenario 'User can delete its own question' do
    login user

    visit questions_path
    
    click_link(question.title)

    expect(page).to have_content question.title

    within('#question-delete') { click_on 'Delete' }

    expect(page).to have_content 'Question successfully deleted!'
    expect(page).not_to have_content question.title
    
  end

  scenario "User can't delete a question that is not its own" do
    login second_user

    visit questions_path

    click_link(question.title)
    
    expect(page).not_to have_css '#question-delete', text: 'Delete'
  end

  scenario "Unathorised user can't delete a question" do
    visit questions_path

    click_link(question.title)
    
    expect(page).not_to have_css '#question-delete', text: 'Delete'
  end
end
