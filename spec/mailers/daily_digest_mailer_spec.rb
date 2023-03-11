# frozen_string_literal: true

require 'rails_helper'

describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user) }
    let(:mail) { described_class.digest(user) }

    describe 'when renders the headers' do
      it 'has mail subject' do
        expect(mail.subject).to eq 'Digest'
      end

      it 'has senders' do
        expect(mail.from).to eq(['from@example.com'])
      end

      it 'has recipients' do
        expect(mail.to).to eq([user.email])
      end
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match 'Questions created last day'
    end
  end
end
