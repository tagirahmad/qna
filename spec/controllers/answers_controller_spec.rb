# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
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
      let(:create_invalid_answer) do
        post :create, params: { question_id: question.id, answer: attributes_for(:answer, :invalid_answer) }
      end

      it 'does not save a new answer' do
        expect { create_invalid_answer }.to change(question.answers, :count).by 0
      end

      it 'renders :new view' do
        create_invalid_answer
        expect(response).to render_template :new
      end
    end
  end
end
