# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe 'Questions API', type: :request do
  let(:headers)      { { 'ACCEPT' => 'application/json' } }
  let(:user)         { create :user }
  let(:access_token) { create :access_token, resource_owner_id: user.id }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like('API Authorizable') { let(:method) { :get } }

    describe 'Authorized' do
      let(:count)           { 2 }
      let(:questions)       { create_list :question, count }
      let(:question)        { questions.first }
      let(:server_response) { json['questions'].last }
      let!(:answers) { create_list :answer, 3, question: question }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API successful status'

      it_behaves_like('API list of resources') { let(:list) { json['questions'] } }

      it_behaves_like 'API fields' do
        let(:entity) { question }
        let(:public_fields) { %w[id title body user_id created_at updated_at user comments answers links] }
      end

      it 'contains user object' do
        expect(server_response['user']['id']).not_to be nil
      end

      it 'contains short title' do
        expect(server_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        it_behaves_like 'API list of resources' do
          let(:count) { 3 }
          let(:list) { json['questions'].last['answers'] }
        end

        it_behaves_like 'API fields' do
          let(:entity) { answers.first }
          let(:server_response) { json['questions'].last['answers'].first }
          let(:public_fields) { %w[id title user_id created_at updated_at] }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user)            { create :user }
    let(:entity)          { create :question, :with_file, user: user }
    let(:server_response) { json['question'] }
    let(:api_path)        { "/api/v1/questions/#{entity.id}" }

    it_behaves_like('API Authorizable') { let(:method) { :get } }

    describe 'Authorized' do
      before do
        create_list :answer, 3, question: entity
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API fields' do
        let(:public_fields) { %w[id title body user_id created_at updated_at user comments answers links] }
      end

      it 'has file' do
        expect(server_response['files'].first).to include entity.files.blobs.first.filename.to_s
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like('API Authorizable') { let(:method) { :post } }

    it_behaves_like 'API create resource', Question do
      let(:public_fields) { %w[id title body created_at updated_at] }
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create :question, user_id: access_token.resource_owner_id }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API update resource', Question do
      let(:instance) { question }
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create :question, user_id: access_token.resource_owner_id }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API delete resource', Question
  end
end
