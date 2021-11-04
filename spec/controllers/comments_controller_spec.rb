# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let!(:question) { create :question }
  let!(:answer)   { create :answer }

  let(:create_question_comment) do
    post :create, params: { question_id: question.id, comment: { comments: attributes_for(:comment) }, format: :js }
  end

  let(:create_answer_comment) do
    post :create, params: { answer_id: answer.id, comment: { comments: attributes_for(:comment) }, format: :js }
  end

  describe 'POST #create' do
    context 'Authorized user creates comment' do
      before { login user }

      context 'with valid attributes' do
        it 'creates comment to question' do
          expect { create_question_comment }.to change(question.comments, :count).by 1
        end

        it 'creates comment to answer' do
          expect { create_answer_comment }.to change(answer.comments, :count).by 1
        end

        it 'new comment has concrete owner' do
          create_question_comment
          expect(assigns(:comment).user).to eq user
        end
      end

      context 'with invalid attributes' do
        subject do
          post :create, params: { question_id: question.id, comment: { comments: attributes_for(:comment, :invalid) }, format: :js }
        end

        it 'not save answer in database' do
          expect { subject }.not_to change(question.comments, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      before { create_question_comment }

      it 'tries to comment' do
        expect { response }.not_to change(question.comments, :count)
      end

      it 'renders login page' do
        expect(response.body).to eql 'You need to sign in or sign up before continuing.'
      end
    end
  end
end
