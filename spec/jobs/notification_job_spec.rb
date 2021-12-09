# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:service)  { instance_double('Notification') }
  let(:users)    { create_list :user, 3 }
  let(:question) { create :question, user: users.first }
  let(:answer)   { create :answer, question: question }

  before { allow(Notification).to receive(:new).and_return(service) }

  it 'calls Notification#notify_about_updates' do
    allow(service).to receive(:notify_about_updates).with(answer, belongs_to: question)
    described_class.perform_now(answer, belongs_to: question)
  end
end
