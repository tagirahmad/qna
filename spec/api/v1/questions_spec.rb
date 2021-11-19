require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT-TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
   context 'unathorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', headers: headers
        
        expect(response.status).to eq 401
      end
      
      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions', params: { access_token: '123' }, headers: headers
        
        expect(response.status).to eq 401
      end
    end

   context 'authorized' do
     let(:access_token) { create :access_token }
     let!(:questions)   { create_list :question, 2 }
     #let!(:question)    { create :question }

     before do
       get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
     end

     it 'returns 200 status' do
       expect(response).to be_successful
     end

     it 'return list of questions' do
       expect(json.size).to eq 2
     end
 
     it 'returns all public fields' do
       %w[id title body user_id].each do |attr|
         expect(json.first[attr]).to eq questions.first.send(attr).as_json
       end
     end
   end
  end
end
