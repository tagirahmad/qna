# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'subscribable' do
  it { is_expected.to have_many(:subscriptions).dependent :destroy }
end
