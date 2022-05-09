# frozen_string_literal: true

require 'rails_helper'

describe 'User can browse questions' do
  let!(:questions) { create_list :question, 3 }

  before { visit questions_path }

  describe 'if there is no any questions' do
    it 'look through questions' do
      expect(page).to have_content 'My title 1'
    end
  end

  describe 'if few questions exist' do
    it 'look through list of questions' do
      questions.each { expect(page).to have_content _1.title }
    end
  end
end
