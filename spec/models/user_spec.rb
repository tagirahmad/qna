# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many :questions }
  it { is_expected.to have_many :answers }
  it { is_expected.to have_many(:rewards).dependent :destroy }
  it { is_expected.to have_many(:votes).dependent :destroy }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  describe '#author_of?' do
    let(:user)          { create :user }
    let(:second_user)   { create :user }
    let(:question)      { create :question }

    context 'when question' do
      let(:user_question) { create :question, user: user }

      it 'user is the author of the question' do
        expect(user).to be_author_of(user_question)
      end

      it 'user is not the author of the question' do
        expect(second_user).not_to be_author_of(user_question)
      end
    end

    context 'when answer' do
      let(:user_answer) { create :answer, user: user, question: question }

      it 'user is the author of the answer' do
        expect(user).to be_author_of(user_answer)
      end

      it 'user is not the author of the answer' do
        expect(second_user).not_to be_author_of(user_answer)
      end
    end
  end
end
