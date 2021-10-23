# frozen_string_literal: true

shared_examples 'voted' do
  let(:user)  { create(:user) }
  let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

  let(:parameters) { { id: model.id, format: :json } }

  describe 'PATCH #vote_up' do
    subject { patch :vote_up, params: parameters }

    describe 'Authorized user' do
      before { login user }

      context 'entity non-owner' do
        it 'can vote up' do
          expect { subject }.to change(model.votes, :count).by 1
        end

        it 'can not vote twice' do
          subject
          subject
          expect(model.votes_score).to eq 1
        end
      end

      context 'entity owner' do
        before { model.update(user_id: user.id) }

        it 'can not vote up' do
          expect { subject }.not_to change(model.votes, :count)
        end
      end
    end

    describe 'Unauthorized user' do
      it 'can not vote up' do
        expect { subject }.not_to change(model.votes, :count)
      end

      it 'gets 401 status Unauthorized' do
        expect(subject).to have_http_status :unauthorized
      end
    end
  end

  describe 'PATCH #vote_down' do
    subject { patch :vote_down, params: parameters }

    describe 'Authorized user' do
      before { login user }

      context 'entity non-owner' do
        it 'can vote down' do
          expect { subject }.to change(model.votes, :count).by 1
        end

        it 'can not vote twice' do
          subject
          subject
          expect(model.votes_score).to eq(-1)
        end
      end

      context 'entity owner' do
        before { model.update(user_id: user.id) }

        it 'can not vote down' do
          expect { subject }.not_to change(model.votes, :count)
        end
      end
    end

    describe 'Unauthorized user' do
      it 'can not vote down' do
        expect { subject }.not_to change(model.votes, :count)
      end

      it 'gets 401 status Unauthorized' do
        expect(subject).to have_http_status :unauthorized
      end
    end
  end

  describe 'DELETE #unvote' do
    subject { delete :unvote, params: parameters }

    describe 'Authorized user' do
      before do
        login user
        patch :vote_up, params: parameters
      end

      context 'entity non-owner' do
        it 'can unvote' do
          expect { subject }.to change(model.votes, :count).by(-1)
        end

        it 'can not unvote twice' do
          subject
          subject
          expect(model.votes_score).to eq 0
        end
      end

      context 'entity owner' do
        before { model.update(user_id: user.id) }

        it 'can not unvote' do
          expect { subject }.not_to change(model.votes, :count)
        end
      end
    end

    describe 'Unauthorized user' do
      it 'can not unvote' do
        expect { subject }.not_to change(model.votes, :count)
      end

      it 'gets 401 status Unauthorized' do
        expect(subject).to have_http_status :unauthorized
      end
    end
  end
end
