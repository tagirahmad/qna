require 'rails_helper'

feature 'The user can view a list of all his rewards.' do
  given!(:users)         { create_list(:user, 2) }
  given!(:questions)     { create_list(:question, 2, user: users.first) }
  given!(:answer)        { create(:answer, question: questions.first, user: users.first) }
  given!(:second_answer) { create(:answer, question: questions.last,  user: users.last) }
  given!(:reward)        { create :reward, :with_image, question: questions.first, user: users.first}
  given!(:second_reward) { create :reward, :with_image, question: questions.last, user: users.last, name: 'second reward'  }

  describe  'Authenticated user' do
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

  describe 'Unauthenticated user 'do
    scenario 'have not link to rewards page' do
      expect(page).not_to have_link 'Rewards'
    end

    scenario 'try to access on rewards page' do
      visit rewards_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
