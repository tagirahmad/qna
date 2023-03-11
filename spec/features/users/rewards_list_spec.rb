# frozen_string_literal: true

require 'rails_helper'

describe 'The user can view a list of all his rewards.' do
  let!(:users)         { create_list(:user, 2) }
  let!(:questions)     { create_list(:question, 2, user: users.first) }
  let!(:answer)        { create(:answer, question: questions.first, user: users.first) }
  let!(:reward)        { create(:reward, :with_image, question: questions.first, user: users.first) }
  let!(:second_reward) do
    create(:reward, :with_image, question: questions.last, user: users.last, name: 'second reward')
  end

  describe 'Authenticated user' do
    before do
      login users.first
      questions.first.update(best_answer_id: answer.id)
      visit rewards_path
    end

    it 'sees his one reward' do
      expect(page).to have_content reward.name
    end

    it 'does not see not his reward' do
      expect(page).not_to have_content second_reward.name
    end
  end

  describe 'Unauthenticated user' do
    it 'does not have link to rewards page' do
      expect(page).not_to have_link 'Rewards'
    end

    it 'tries to access on rewards page' do
      visit rewards_path
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
