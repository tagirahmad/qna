shared_examples_for 'API fields' do
  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(server_response[attr]).to eq entity.send(attr).as_json
    end
  end

  if method_defined? :private_fields
    it 'does not return private fields' do
      private_fields&.each do |attr|
        expect(server_response).not_to have_key attr
      end
    end
  end
end
