# frozen_string_literal: true

require 'rails_helper'

describe 'User can vote on answer' do
  let(:user) { create :user }
  let(:second_user) { create :user }
  let(:third_user) { create :user }
  let(:question) { create :question }
  let!(:answer) { create :answer, question: question, user: user }

  it 'Unauthorized user can not vote for answer', :js do
    visit question_path question

    within '.answers' do
      click_on 'Vote up'

      expect(page).to have_content '0'
    end

    # expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'Authorized user' do
    describe 'answer author', js: true do
      it 'shows message author can not vote' do
        login user
        visit question_path question
        click_on 'Vote up'

        expect(page).to have_content 'Author can not vote'
      end
    end

    describe 'answer non-author' do
      before do
        login second_user
        visit question_path question
      end

      it 'votes up', js: true do
        click_on 'Vote up'
        expect(page).to have_content '1'
      end

      it 'votes down', js: true do
        click_on 'Vote down'
        expect(page).to have_content '-1'
      end

      it 'unvotes', js: true do
        click_on 'Unvote'
        expect(page).to have_content '0'
      end

      it 'revote', js: true do
        click_on 'Vote up'
        expect(page).to have_content '1'

        click_on 'Vote down'
        expect(page).to have_content '-1'
      end

      it 'votes on already voted answer', js: true do
        answer.votes.create!(user_id: third_user.id, value: 1)

        click_on 'Vote up'

        expect(page).to have_content '2'
      end

      it 'can not vote twice', js: true do
        click_on 'Vote up'
        click_on 'Vote up'

        expect(page).to have_content '1'
      end
    end
  end
end
