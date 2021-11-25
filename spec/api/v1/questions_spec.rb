require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token)      { create :access_token }
      let(:count)             { 2 }
      let(:answers_count)     { 3 }
      let!(:questions)  { create_list :question, count }
      let(:list)              { json['questions'] }
      let(:question)          { questions.first }
      let(:entity)            { question }
      let(:server_response)   { json['questions'].first }
      let!(:answers)    { create_list :answer, answers_count, question: question }
      let(:public_fields)     { %w[id title body user_id created_at updated_at user comments answers links] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API successful status'

      it_behaves_like 'API list of entities'
      
      it_behaves_like 'API public fields'

      it 'contains user object' do
        expect(server_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(server_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:entity)          { answers.first  }
        let(:list)            { json['questions'].first['answers'] }
        let(:server_response) { json['questions'].first['answers'].first }
        let(:count)           { 3 }
        let(:public_fields)   { %w[id title user_id created_at updated_at] }

        it_behaves_like 'API list of entities'

        it_behaves_like 'API public fields'
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user)              { create :user }
    let(:entity)            { create :question, :with_file, user: user }
    let(:server_response)   { json['question'] }
    let!(:comments)   { create_list :comment, 2, commentable: entity, user: user }
    let!(:links)      { create_list :link, 2, linkable: entity }
    let(:access_token)      { create :access_token }
    let(:api_path)          { "/api/v1/questions/#{entity.id}" }
    let(:public_fields)     { %w[id title body user_id created_at updated_at user comments answers links] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list :answer, 3, question: entity }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API public fields'

      it 'has file' do
        expect(server_response['files'].first).to include entity.files.blobs.first.filename.to_s
      end
    end
  end
end
