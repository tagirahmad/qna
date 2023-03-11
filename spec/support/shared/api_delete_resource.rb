# frozen_string_literal: true

shared_examples_for 'API delete resource' do |resource|
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:klass)   { resource.to_s.downcase.to_sym }
  let(:delete_resource) { delete api_path, params: { access_token: access_token.token }, headers: }

  it 'deletes question' do
    expect { delete_resource }.to change(resource, :count).by(-1)
  end

  it_behaves_like 'API successful status', :delete_resource
end
