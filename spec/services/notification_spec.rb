# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification do
  subject(:notification) { described_class.new }

  let(:users)    { create_list(:user, 3) }
  let(:question) { create(:question, user: users.first) }
  let(:answer)   { create(:answer, question:) }

  it 'sends notification about new record' do
    users.each { allow(NotificationMailer).to receive(:notify_about_updates).with(answer, _1).and_call_original }

    notification.notify_about_updates(answer, belongs_to: question)
  end
end
