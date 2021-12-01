shared_examples_for 'API update resource' do |resource|
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass)   { resource.to_s.downcase.to_sym }

  context 'with valid attrs' do
    describe "updates the #{resource.to_s} resource" do
      let(:changed_fields) { attributes_for(klass, :updated) }

      before do
        patch api_path, params: { access_token: access_token.token,
                                  klass => changed_fields }, headers: headers
      end

      it 'updates attrs' do
        changed_fields.each do |attr, _val|
          expect(instance.reload.send(attr)).to eq changed_fields[attr]
        end
      end
    end
  end

  context 'with invalid attrs' do
    let(:invalid_attrs) { attributes_for(klass, :invalid) }
    let(:try_to_update_entity) do
      patch api_path,
            params: { access_token: access_token.token, klass => invalid_attrs },
            headers: headers
    end

    it "does not update the #{resource.to_s} resource" do
      invalid_attrs.each do |attr, _value|
        expect{ try_to_update_entity }.not_to change instance.reload, attr
      end
    end

    it 'returns response with validator errors' do
      try_to_update_entity
      expect(json['errors']).to all(satisfy { |err| err.include? 'can\'t be blank' })
    end
  end
end
