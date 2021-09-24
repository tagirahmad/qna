# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to :question }
  it { is_expected.to validate_presence_of :title }

  describe 'creation' do
    let!(:user)     { create :user }
    let!(:question) { create :question, best_answer_id: nil }
    let!(:answer)   { create :answer, question: question, user: user }

    it '#mark_as_best' do
      question.update(best_answer_id: answer.id)
      question.reload

      expect(question).to have_attributes(best_answer_id: answer.id)
    end
  end
end
