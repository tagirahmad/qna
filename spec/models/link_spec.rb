# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:second_link) { build(:link, name: 'Second', url: 'https://google.ru', linkable: question) }
  let(:link)     { build(:link, name: 'First', url: 'https://gist.github.com/', linkable: question) }
  let(:question) { create :question, user: user }
  let(:user)     { create :user }

  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to allow_value('https://google.com').for(:url) }
  it { is_expected.not_to allow_value('google').for(:url) }

  it '#gist?' do
    expect(link).to be_gist
    expect(second_link).not_to be_gist
  end
end
