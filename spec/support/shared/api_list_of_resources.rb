# frozen_string_literal: true

shared_examples_for 'API list of resources' do
  it 'returns resources count' do
    expect(list.size).to eq count
  end
end
