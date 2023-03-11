# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'commentable'

  it { is_expected.to belong_to :question }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to accept_nested_attributes_for :links }

  describe 'creation' do
    let(:user)          { create(:user) }
    let(:second_user)   { create(:user) }
    let(:question)      { create(:question, best_answer_id: nil, user:) }
    let(:answer)        { create(:answer, question:, user: second_user) }

    describe '#mark_as_best' do
      before { question.update(best_answer_id: answer.id) }

      it 'question has best answer' do
        expect(question).to have_attributes(best_answer_id: answer.id)
      end

      it "question's answer author achieved a reward" do
        create(:reward, question:)
        question.reward.update(user: answer.user)

        expect(question.reward).to have_attributes(user: second_user)
      end
    end

    describe '#best_answer?' do
      let(:second_answer) { create(:answer, question:, user: second_user) }

      before { question.update(best_answer_id: answer.id) }

      it 'sets the right best answer' do
        expect(question.best_answer_id).to eq(answer.id)
      end

      it 'does not set wrong best answer' do
        expect(question.best_answer_id).not_to eq(second_answer.id)
      end
    end

    it '#notify_subscribers' do
      notification_job = class_double NotificationJob

      allow(notification_job).to receive(:perform_later).with(answer, belongs_to: answer.question)
      notification_job.perform_later(answer, belongs_to: answer.question)
    end
  end
end
