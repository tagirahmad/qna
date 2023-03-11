# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question)    { create(:question, user:) }
  let(:second_user) { create(:user) }
  let(:user)        { create(:user) }

  it_behaves_like 'voted'

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login user }

      it 'saves a new answer into db' do
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js
        end.to change(question.answers, :count).by 1
      end
    end

    context 'with invalid attributes' do
      before do
        login user
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid) }, format: :js
      end

      it 'does not save a new answer' do
        expect { response }.not_to change(question.answers, :count)
      end

      it 'returns status code unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, user:) }

    context 'when answer belongs to user' do
      it 'delete answer' do
        login user
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'when answer does not belong to user' do
      it 'can not delete can not its own answer' do
        login second_user
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question:, user:) }

    before { login user }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { title: 'new title' } }, format: :js
        answer.reload
        expect(answer.title).to eq 'new title'
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(answer, :title)
      end
    end
  end

  describe '#mark_as_best', js: true do
    let!(:answer) { create(:answer, question:, user:) }

    before do
      create(:reward, question: answer.question)
      login user
      patch :mark_as_best, params: { id: answer }, format: :js
      answer.reload
    end

    it 'makes the answer as best' do
      expect(answer.question.best_answer_id).to eq answer.id
    end

    it 'gives to answers author a reward' do
      expect(answer.question.reward.user).to eq answer.user
    end
  end
end
