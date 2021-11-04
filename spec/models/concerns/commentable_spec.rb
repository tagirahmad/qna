# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples_for 'commentable' do
  it { is_expected.to have_many(:comments).dependent(:delete_all) }
end
