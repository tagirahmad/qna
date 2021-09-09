# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answers' do
  given(:user)        { create :user }
  given(:second_user) { create :user }
  given!(:question)   { create :question }
  given!(:answer)     { create :answer, question: question, user: user }

  scenario 'User can delete only its own answers' do
    login user
    visit questions_path

    click_link(question.title)
    
    expect(page).to have_content answer.title

    within("#answer-delete-#{answer.id}") { click_on 'Delete' }

    expect(page).not_to have_content answer.title
    expect(page).to have_content 'Answer successfully deleted!'
  end

  scenario "User can not delete not its own answer" do
    login second_user
    visit questions_path

    click_link(question.title)

    expect(page).to have_content answer.title
    expect(page).not_to have_css "#answer-delete-#{answer.id}", text: 'Delete' 
  end

  scenario "Unathenticated can not delete not its own answer" do
    visit questions_path

    click_link(question.title)

    expect(page).to have_content answer.title
    expect(page).not_to have_css "#answer-delete-#{answer.id}", text: 'Delete' 
  end
end
