# frozen_string_literal: true

shared_examples_for 'API update resource' do |resource|
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass)   { resource.to_s.downcase.to_sym }

  context 'with valid attrs' do
    describe "updates the #{resource} resource" do
      let(:changed_fields) { attributes_for(klass, :updated) }

      before do
        patch api_path, params: { access_token: access_token.token, klass => changed_fields }, headers:
      end

      it 'updates attrs' do
        changed_fields.each { |attr, _val| expect(instance.reload.send(attr)).to eq changed_fields[attr] }
      end
    end
  end

  context 'with invalid attrs' do
    let(:invalid_attrs) { attributes_for(klass, :invalid) }

    before { patch api_path, params: { access_token: access_token.token, klass => invalid_attrs }, headers: }

    it "does not update the #{resource} resource" do
      invalid_attrs.each { |attr, _value| expect { response }.not_to change instance.reload, attr }
    end

    it 'returns response with validator errors' do
      expect(json['errors']).to all(satisfy { |err| err.include? 'can\'t be blank' })
    end
  end
end
