# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to have_many(:answers).dependent(:destroy) }

  it 'has one attached file' do
    expect(described_class.new.file).to be_an_instance_of ActiveStorage::Attached::One
  end
end
