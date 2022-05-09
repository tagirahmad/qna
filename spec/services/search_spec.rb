# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, sphinx: true do
  let(:search)   { described_class }
  let(:question) { create :question }

  context 'when finding the desired result' do
    it 'with passed scope' do
      allow(question.class).to receive(:search).with(question.body).and_return [question]
      search.call(question.body, 'Question')
    end

    it 'without passed scope' do
      allow(ThinkingSphinx).to receive(:search).with(question.body).and_return [question]
      search.call(question.body)
    end
  end
end
