# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:access_token) { create :access_token }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:count) { 2 }
      let(:answers_count) { 3 }
      let!(:questions) { create_list :question, count }
      let(:list) { json['questions'] }
      let(:question) { questions.first }
      let(:entity) { question }
      let(:server_response) { json['questions'].first }
      let!(:answers) { create_list :answer, answers_count, question: question }
      let(:public_fields) { %w[id title body user_id created_at updated_at user comments answers links] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API successful status'

      it_behaves_like 'API list of entities'

      it_behaves_like 'API fields'

      it 'contains user object' do
        expect(server_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(server_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:entity) { answers.first }
        let(:list) { json['questions'].first['answers'] }
        let(:server_response) { json['questions'].first['answers'].first }
        let(:count) { 3 }
        let(:public_fields) { %w[id title user_id created_at updated_at] }

        it_behaves_like 'API list of entities'

        it_behaves_like 'API fields'
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create :user }
    let(:entity) { create :question, :with_file, user: user }
    let(:server_response) { json['question'] }
    let!(:comments) { create_list :comment, 2, commentable: entity, user: user }
    let!(:links) { create_list :link, 2, linkable: entity }
    let(:api_path) { "/api/v1/questions/#{entity.id}" }
    let(:public_fields) { %w[id title body user_id created_at updated_at user comments answers links] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list :answer, 3, question: entity }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API fields'

      it 'has file' do
        expect(server_response['files'].first).to include entity.files.blobs.first.filename.to_s
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      context 'with valid attrs' do
        before do
          post api_path, params: { access_token: access_token.token,
                                   question: { title: 'Title', body: 'Body' } }, headers: headers
        end

        it_behaves_like 'API successful status'

        it 'creates and returns new question' do
          %w[id title body created_at updated_at].each do |attr|
            expect(json['question'][attr].as_json).to eq Question.last.send(attr).as_json
          end
        end

        it 'does not return array with errors' do
          expect(json).not_to have_key 'errors'
        end
      end

      context 'with invalid attrs' do
        it 'returns response with validator errors' do
          post api_path, params: { access_token: access_token.token, question: { title: '', body: '' } },
               headers: headers

          expect(json['errors']).to all(satisfy { |err| err.include? 'can\'t be blank' })
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:id' do
    let(:question) { create :question, user_id: access_token.resource_owner_id }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    context 'with valid attrs' do
      describe 'updates the question' do
        before do
          patch api_path,
                params: { access_token: access_token.token, question: { title: 'Changed title', body: 'Changed body' } },
                headers: headers
        end

        it 'updates title' do
          expect(Question.find(question.id).title).to eq 'Changed title'
        end

        it 'updates body' do
          expect(Question.find(question.id).body).to eq 'Changed body'
        end
      end
    end

    describe 'with invalid attrs' do
      let(:try_to_update_answer) do
        patch api_path,
              params: { access_token: access_token.token, question: { title: '' } },
              headers: headers
      end

      it 'does not update question' do
        expect{ try_to_update_answer }.not_to change Question.find(question.id), :title
      end

      it 'returns response with validator errors' do
        try_to_update_answer
        expect(json['errors']).to all(satisfy { |err| err.include? 'can\'t be blank' })
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create :question, user_id: access_token.resource_owner_id }
    let(:api_path)        { "/api/v1/questions/#{question.id}" }
    let(:delete_question) { delete api_path, params: { access_token: access_token.token }, headers: headers }

    it 'deletes question' do
      expect { delete_question }.to change(Question, :count).by(-1)
    end

    it_behaves_like 'API successful status', :delete_question
  end
end
