# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe Ability do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { is_expected.to be_able_to :read, Question }
    it { is_expected.to be_able_to :read, Answer }
    it { is_expected.to be_able_to :read, Comment }

    it { is_expected.not_to be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)        { create(:user) }
    let(:second_user) { create(:user) }
    let(:question)        { create(:question, user:) }
    let(:second_question) { create(:question, user: second_user) }
    let(:subscription)        { create(:subscription, subscribeable: question, user:) }
    let(:second_subscription) { create(:subscription, subscribeable: question, user: second_user) }

    context 'when guest' do
      it { is_expected.to     be_able_to :read, :all }
      it { is_expected.not_to be_able_to :manage, :all }
    end

    context 'when question' do
      it { is_expected.to be_able_to :create, Question }

      it { is_expected.to     be_able_to(:update,  question, user:) }
      it { is_expected.not_to be_able_to(:update,  second_question, user:) }

      it { is_expected.to     be_able_to(:destroy, question, user:) }
      it { is_expected.not_to be_able_to(:destroy, second_question, user:) }
    end

    context 'when answer' do
      let(:answer)        { create(:answer, question:, user:) }
      let(:second_answer) { create(:answer, question: second_question, user: second_user) }

      it { is_expected.to     be_able_to :create, Answer }

      it { is_expected.to     be_able_to(:update, answer, user:) }
      it { is_expected.not_to be_able_to(:update, second_answer, user:) }

      it { is_expected.to     be_able_to(:destroy, answer, user:) }
      it { is_expected.not_to be_able_to(:destroy, second_answer, user:) }
    end

    context 'when comment' do
      let(:comment)        { create(:comment, commentable: question, user:) }
      let(:second_comment) { create(:comment, commentable: question, user: second_user) }

      it { is_expected.to     be_able_to :create, Comment }

      it { is_expected.to     be_able_to(:update, comment, user:) }
      it { is_expected.not_to be_able_to(:update, second_comment, user:) }

      it { is_expected.to     be_able_to(:destroy, comment, user:) }
      it { is_expected.not_to be_able_to(:destroy, second_comment, user:) }
    end

    # TODO: add tests for subscription abilities
    # context 'when subscription' do
    #   let(:subscription)        { create :subscription, subscribeable: question, user: user }
    #   let(:second_subscription) { create :subscription, subscribeable: question, user: second_user }
    #
    #   it { is_expected.to     be_able_to :create, Subscription }
    #
    #   it { is_expected.to     be_able_to :destroy, subscription,        user: user }
    #   it { is_expected.not_to be_able_to :destroy, second_subscription, user: user }
    # end
  end
end
