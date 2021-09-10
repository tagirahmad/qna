# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:second_user)   { create :user }
  let(:question) { create :question, user: user }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login user }

      let(:create_answer) { post :create, params: { question_id: question.id, answer: attributes_for(:answer) } }

      it 'saves a new answer into db' do
        expect { create_answer }.to change(question.answers, :count).by 1
      end

      it 'redirects to question path' do
        create_answer
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { login user }

      let(:create_invalid_answer) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) }
      end

      it 'does not save a new answer' do
        expect { create_invalid_answer }.to change(question.answers, :count).by 0
      end

      it 're-renders question view' do
        create_invalid_answer
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create :answer, user: user }

    context 'when answer belongs to user' do
      let(:delete_answer) { delete :destroy, params: { id: answer } }

      before { login user }

      it 'delete answer' do
        expect { delete_answer }.to change(Answer, :count).by(-1)
        expect(response).to  redirect_to answer.question
      end

      it 'redurects to question#show' do
        delete_answer
        expect(response).to  redirect_to answer.question
      end
    end

    context 'when answer does not belong to user' do
      let(:delete_answer) { delete :destroy, params: { id: answer } }

      before { login second_user }

      it 'can not delete can not its own answer' do
        expect { delete_answer }.not_to change(Answer, :count)
      end

      it 'redirects to question#show' do
        delete_answer
        expect(response).to redirect_to answer.question
      end
    end
  end
end
