# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'commentable'
  it_behaves_like 'subscribable'

  it { is_expected.to have_many(:answers).dependent :destroy }
  it { is_expected.to have_one(:reward).dependent :destroy }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to accept_nested_attributes_for :links }
  it { is_expected.to accept_nested_attributes_for :reward }

  it 'has many attached files' do
    expect(described_class.new.files).to be_an_instance_of ActiveStorage::Attached::Many
  end

  it 'creates subscription after create question' do
    expect { create(:question) }.to change(Subscription, :count).by 1
  end
end
