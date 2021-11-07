# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it { is_expected.to have_many(:links).dependent :destroy }

  it { is_expected.to belong_to :question }
  it { is_expected.to validate_presence_of :title }

  it { is_expected.to accept_nested_attributes_for :links }

  describe 'creation' do
    let(:user)          { create :user }
    let(:question)      { create :question, best_answer_id: nil }
    let!(:reward)       { create :reward, question: question }
    let(:answer)        { create :answer, question: question, user: user }
    let(:second_answer) { create :answer, question: question, user: user }

    describe '#mark_as_best' do
      before do
        question.update(best_answer_id: answer.id)
      end

      it 'question has best answer' do
        expect(question).to have_attributes(best_answer_id: answer.id)
      end

      it "question's answer author achieved a reward" do
        question.reward.update(user: answer.user)

        expect(question.reward).to have_attributes(user: user)
      end
    end

    it '#best_answer?' do
      question.update(best_answer_id: answer.id)

      expect(question.best_answer_id).to eq(answer.id)
      expect(question.best_answer_id).not_to eq(second_answer.id)
    end
  end
end
