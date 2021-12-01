shared_examples_for 'API successful status' do |action|
  it 'returns 200 status' do
    send action if action
    expect(response).to be_successful
  end
end
