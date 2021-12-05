# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'linkable' do
  it { is_expected.to have_many(:links).dependent :destroy }
end

