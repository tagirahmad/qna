shared_examples_for 'API list of entities' do
  it 'returns list of entities' do
    expect(list.size).to eq count
  end
end
