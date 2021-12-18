# frozen_string_literal: true

require 'rails_helper'

describe 'User can browse questions' do
  let(:user) { create :user }
  let!(:questions) { create_list :question, 3 }

  before do
    visit questions_path
  end

  describe 'if there is no any questions' do
    it 'look through questions' do
      expect(page).to have_content 'My title 1'
    end
  end

  describe 'if few questions exist' do
    it 'look through list of questions' do
      questions.each do |q|
        expect(page).to have_content q.title
      end
    end
  end
end
