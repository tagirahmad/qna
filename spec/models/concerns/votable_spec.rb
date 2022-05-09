# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:user)        { create(:user) }
  let(:second_user) { create(:user) }
  let(:model)       { create(described_class.to_s.underscore.to_sym, user: user) }

  it { is_expected.to have_many(:votes).dependent(:destroy) }

  describe '#vote_up' do
    context 'when votable owner' do
      it 'model has zero votes' do
        model.vote_up(user)
        expect(model.votes_score).to eq 0
      end
    end

    context 'when votable non-owner' do
      before { model.vote_up(second_user) }

      it 'model has one vote' do
        expect(model.votes_score).to eq 1
      end

      it 'can not vote again' do
        model.vote_up(second_user)
        expect(model.votes_score).to eq 1
      end
    end
  end

  describe '#vote_down' do
    context 'when votable owner' do
      it 'model has zero votes' do
        model.vote_down(user)
        expect(model.votes_score).to eq 0
      end
    end

    context 'when votable non-owner' do
      before { model.vote_down(second_user) }

      it 'model has -1 vote' do
        model.vote_down(second_user)
        expect(model.votes_score).to eq(-1)
      end

      it 'can not unvote again' do
        expect(model.votes_score).to eq(-1)
      end
    end
  end

  describe '#unvote' do
    context 'when unvotes' do
      before { model.vote_up(second_user) }

      it 'decreases votes count by one' do
        expect { model.unvote(second_user) }.to change(model.votes, :count).by(-1)
      end

      it 'decreases total votes score by one' do
        expect { model.unvote(second_user) }.to change(model, :votes_score).from(1).to 0
      end

      it 'declares that there is no such voted user' do
        model.unvote(second_user)
        expect(model.votes.exists?(user: second_user)).to be false
      end
    end
  end
end
