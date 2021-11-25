shared_examples_for 'API public fields' do
  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(server_response[attr]).to eq entity.send(attr).as_json
    end
  end
end
