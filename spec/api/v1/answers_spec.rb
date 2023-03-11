# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
describe 'Answers API', type: :request do
  let(:headers)      { { 'ACCEPT' => 'application/json' } }
  let(:user)         { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:question)     { create(:question, user_id: access_token.resource_owner_id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    describe 'Authorized' do
      let(:count) { 3 }
      let!(:answers) { create_list(:answer, count, :with_file, question:) }
      let(:answer)          { answers.first }
      let(:server_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: }

      it_behaves_like 'API successful status'

      it_behaves_like 'API list of resources' do
        let(:list) { json['answers'] }
      end

      it_behaves_like 'API fields' do
        let(:entity)        { answer }
        let(:public_fields) { %w[id title user_id created_at updated_at comments links] }
      end

      it 'has file' do
        expect(server_response['files'].first).to include answer.files.blobs.first.filename.to_s
      end

      it 'contains user object' do
        expect(server_response['user']['id']).to eq answer.user.id
      end

      it 'answer belongs to question' do
        expect(server_response['question_id']).to eq question.id
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers/:id' do
    let(:answer) { create(:answer, :with_file, question:) }
    # rubocop:disable RSpec/LetSetup
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:server_response) { json['answer'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    describe 'authorized' do
      before { get api_path, params: { access_token: access_token.token }, headers: }

      it_behaves_like 'API fields' do
        let(:entity)        { answer }
        let(:public_fields) { %w[id title user_id created_at updated_at comments links] }
      end

      it 'has file' do
        expect(server_response['files'].first).to include answer.files.blobs.first.filename.to_s
      end
    end
  end

  describe 'POST /api/v1/questions/:id/answers/' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    it_behaves_like 'API create resource', Answer do
      let(:public_fields) { %w[id title created_at updated_at] }
    end
  end

  describe 'PATCH /api/v1/questions/:id/answers/:id' do
    let(:answer)   { create(:answer, question:, user_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API update resource', Answer do
      let(:instance) { answer }
    end
  end

  describe 'DELETE /api/v1/questions/:id/answers/:id' do
    let!(:answer) { create(:answer, question:, user_id: access_token.resource_owner_id) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API delete resource', Answer
  end
end
