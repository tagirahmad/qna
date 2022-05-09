# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigest do
  subject(:daily_digest) { described_class.new }

  let(:users) { create_list :user, 3 }

  it 'sends daily digest to all users' do
    users.each { allow(DailyDigestMailer).to receive(:digest).with(_1).and_call_original }
    daily_digest.send_digest
  end
end
