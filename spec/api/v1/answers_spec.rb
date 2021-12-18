# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers)      { { 'ACCEPT' => 'application/json' } }
  let(:user)         { create :user }
  let(:access_token) { create :access_token, resource_owner_id: user.id }
  let(:question)     { create :question, user_id: access_token.resource_owner_id }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:second_question) { create :question }
      let(:count)           { 3 }
      let!(:answers) { create_list :answer, count, :with_file, question: question }
      let(:list)            { json['answers'] }
      let(:answer)          { answers.first }
      let(:entity)          { answer }
      let(:server_response) { json['answers'].first }
      let(:public_fields)   { %w[id title user_id created_at updated_at comments links] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API successful status'

      it_behaves_like 'API list of resources'

      it_behaves_like 'API fields'

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
    let(:answer)          { create :answer, :with_file, question: question }
    let(:entity)          { answer }
    let!(:links) { create_list :link, 2, linkable: answer }
    let(:api_path)        { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    let(:server_response) { json['answer'] }
    let(:public_fields)   { %w[id title user_id created_at updated_at comments links] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API fields'

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
    let(:answer)   { create :answer, question: question, user_id: access_token.resource_owner_id }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API update resource', Answer do
      let(:instance) { answer }
    end
  end

  describe 'DELETE /api/v1/questions/:id/answers/:id' do
    let!(:answer) { create :answer, question: question, user_id: access_token.resource_owner_id }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API delete resource', Answer
  end
end
