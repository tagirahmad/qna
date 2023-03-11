# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user)          { create(:user) }
  let(:second_user)   { create(:user) }
  let(:question)      { create(:question, user:) }
  let(:answer) { create(:answer, user:, question:) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders :index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns new link to answer, best and other answers' do
      expect(assigns(:answer).links.first).to be_a_new Link
    end

    it 'assigns other answers' do
      expect(assigns(:other_answers)).to match_array question.answers
    end

    it 'renders :show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before do
      login user
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new Question
    end

    it 'assigns a new Link to @question' do
      expect(assigns(:question).links.first).to be_a_new Link
    end

    it 'renders :new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before do
      login user
      get :edit, params: { id: question }
    end

    it 'renders :edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login user }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by 1
      end

      it 'redirects to :show view' do
        post :create, params: { question: attributes_for(:question) }
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login user }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        expect do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload
        end.to change(question, :title).to('new title')
                                       .and change(question, :body).to('new body')
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        expect { question.reload }.not_to change(question, :body)
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user:) }
    let(:delete_question) { delete :destroy, params: { id: question } }

    context 'when question belongs to user' do
      before { login user }

      describe 'deletes its own question' do
        it 'deletes the question' do
          expect { delete_question }.to change(Question, :count).by(-1)
        end

        it 'redirects to questions#index' do
          delete_question
          expect(response).to redirect_to questions_path
        end
      end
    end

    describe 'if question does not belong to user' do
      context 'when authenticated user' do
        before { login second_user }

        it 'can not delete not its own question' do
          expect { delete_question }.not_to change(Question, :count)
        end

        it 'redirects to list of questions' do
          delete_question
          expect(response).to redirect_to questions_path
        end
      end

      context 'when unauthenticated user' do
        it 'can not delete not its own question' do
          expect { delete_question }.not_to change(Question, :count)
        end

        it 'redirects to login page' do
          delete_question
          expect(response).to redirect_to new_user_session_path
        end
      end
    end
  end
end
