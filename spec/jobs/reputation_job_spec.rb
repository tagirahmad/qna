require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { create(:question) }

  it 'calls ReputationJob' do
    allow(Reputation).to receive(:calculate).with(question)
    described_class.perform_now(question)
  end
end
