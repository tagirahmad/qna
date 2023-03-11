# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:user)     { create(:user) }
  let(:question) { create(:question, user:) }
  let(:link)     { build(:link, name: 'First', url: 'https://gist.github.com/', linkable: question) }
  let(:second_link) { build(:link, name: 'Second', url: 'https://google.ru', linkable: question) }

  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to allow_value('https://google.com').for(:url) }
  it { is_expected.not_to allow_value('google').for(:url) }

  describe '#gist?' do
    it 'be a gist' do
      expect(link).to be_gist
    end

    it 'is not a gist' do
      expect(second_link).not_to be_gist
    end
  end
end
