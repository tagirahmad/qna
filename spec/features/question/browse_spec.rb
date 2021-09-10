# frozen_string_literal: true

require 'rails_helper'

feature 'User can browse questions' do
  given(:user) { create :user }
  given!(:questions) { create_list :question, 3 }

  background do
    visit questions_path
  end

  describe 'if there is no any questions' do
    scenario 'look through questions' do
      expect(page).to have_content 'Ask question'
    end
  end

  describe 'if few questions exist' do
    scenario 'look through list of questions' do
      questions.each do |q|
        expect(page).to have_content q.title
      end
    end
  end
end
