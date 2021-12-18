# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search, sphinx: true do
  let(:search)   { described_class }
  let(:question) { create :question }

  context 'when finding the desired result' do
    it 'with passed scope' do
      expect(question.class).to receive(:search).with(question.body).and_return [question]
      search.call(question.body, 'Question')
    end

    it 'without passed scope' do
      expect(ThinkingSphinx).to receive(:search).with(question.body).and_return [question]
      search.call(question.body)
    end
  end
end
