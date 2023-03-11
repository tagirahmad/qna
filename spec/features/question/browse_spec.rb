# frozen_string_literal: true

require 'rails_helper'

describe 'User can browse questions' do
  let!(:questions) { create_list(:question, 3) }

  describe 'if few questions exist' do
    it 'look through list of questions' do
      visit questions_path
      questions.each { expect(page).to have_content _1.title }
    end
  end
end
