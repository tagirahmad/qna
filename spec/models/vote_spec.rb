# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to belong_to :votable }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :value }

  it { is_expected.to validate_inclusion_of(:votable_type).in_array(%w[Question Answer]) }
  it { is_expected.to validate_inclusion_of(:value).in_array([-1, 1]) }

  describe '#not_votable_author?' do
    let(:question)    { create(:question) }
    let(:user)        { create(:user) }
    let(:second_user) { create(:user) }

    before { question.vote_up(user) }

    it 'for vote owner' do
      expect(question.votes.first.user_id).to eq user.id
    end

    it 'for non-owner' do
      expect(question.votes.first.user_id).not_to eq second_user.id
    end
  end
end
