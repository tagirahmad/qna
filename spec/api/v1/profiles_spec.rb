# frozen_string_literal: true
require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:entity)          { create :user }
      let(:access_token)    { create :access_token, resource_owner_id: entity.id }
      let(:server_response) { json['user'] }
      let(:public_fields)   { %w[id email admin created_at updated_at] }
      let(:private_fields)  { %w[password encrypted_password] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API successful status'

      it_behaves_like 'API fields'
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles/' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me)           { create :user }
      let!(:second_user)  { create :user }
      let(:entity)              { second_user }
      let(:access_token)        { create :access_token, resource_owner_id: me.id }
      let(:public_fields)       { %w[id email admin created_at updated_at] }
      let(:server_response)     { json['users'].first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'API successful status'

      it_behaves_like 'API fields'

      it 'returns list of users except current' do
        expect(json['users'].size).to eq User.where.not(id: me.id).size
      end
    end
  end
end
