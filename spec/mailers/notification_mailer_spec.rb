# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationMailer, type: :mailer do
  describe '#notify_about_updates_of' do
    let(:user)     { create :user }
    let(:question) { create :question }
    let(:answer)   { create :answer }
    let(:mail)     { described_class.notify_about_updates(answer, user) }

    it 'renders the headers' do
      expect(mail.subject).to eq("New #{answer.class.to_s.downcase} is appeared!")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the answer title' do
      expect(mail.body.encoded).to match("New answer #{answer.title} has been received!")
    end
  end
end
