shared_examples_for 'API create resource' do |resource|
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass) { resource.to_s.downcase.to_sym }

  context 'with valid attrs' do
    before do
      post api_path, params: { access_token: access_token.token,
                               klass => attributes_for(klass) }, headers: headers
    end

    it_behaves_like 'API successful status'

    it_behaves_like 'API fields' do
      let(:server_response) { json[klass.to_s] }
      let(:entity) { resource.last }
    end

    it 'does not return response with errors' do
      expect(json).not_to have_key 'errors'
    end
  end

  context 'with invalid attrs' do
    it 'returns response with validator errors' do
      post api_path, params: { access_token: access_token.token,
                               klass => attributes_for(klass, :invalid) },
                     headers: headers

      expect(json['errors']).to all(satisfy { |err| err.include? 'can\'t be blank' })
    end
  end
end
