# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:user)        { create :user }
  let(:second_user) { create :user }
  let(:question)    { create :question, user: user }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login user }

      let(:create_answer) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer) }, format: :js
      end

      it 'saves a new answer into db' do
        expect { create_answer }.to change(question.answers, :count).by 1
      end

      it 'redirects to question path' do
        create_answer
        # expect(response).to redirect_to question
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login user }

      let(:create_invalid_answer) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) },
                      format: :js
      end

      it 'does not save a new answer' do
        expect { create_invalid_answer }.to change(question.answers, :count).by 0
      end

      it 're-renders question view' do
        create_invalid_answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer, user: user }

    context 'when answer belongs to user' do
      let(:delete_answer) { delete :destroy, params: { id: answer }, format: :js }

      before { login user }

      it 'delete answer' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question#show' do
        delete_answer
      end
    end

    context 'when answer does not belong to user' do
      let(:delete_answer) { delete :destroy, params: { id: answer }, format: :js }

      before { login second_user }

      it 'can not delete can not its own answer' do
        expect { delete_answer }.not_to change(Answer, :count)
      end

      it 'redirects to question#show' do
        delete_answer
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    before { login user }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { title: 'new title' } }, format: :js
        answer.reload
        expect(answer.title).to eq 'new title'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { title: 'new title' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        end.not_to change(answer, :title)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid_answer) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe '#mark_as_best', js: true do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:reward) { create :reward, question: answer.question }
    
    before do 
      login user
      patch :mark_as_best,  params: { id: answer }, format: :js
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
