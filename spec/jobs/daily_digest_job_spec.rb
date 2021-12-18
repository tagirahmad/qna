# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { instance_double('DailyDigest') }

  before do
    allow(DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls DailyDigest#send_digest' do
    allow(service).to receive(:send_digest)
    described_class.perform_now
  end
end
