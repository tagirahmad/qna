# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :commentable }

  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_inclusion_of(:commentable_type).in_array(%w[Question Answer]) }
end
