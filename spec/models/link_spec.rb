# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { is_expected.to belong_to :linkable }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to allow_value('https://google.com').for(:url) }
  it { is_expected.not_to allow_value('google').for(:url) }
  
  let(:user)     { create :user }
  let(:question) { create :question, user: user }
  let(:link)     { build(:link, name: 'First', url: 'https://gist.github.com/', linkable: question) }
  let(:second_link) { build(:link, name: 'Second', url: 'https://google.ru', linkable: question) }

  it '#gist?' do
    expect(link).to be_gist
    expect(second_link).to_not be_gist
  end
end
