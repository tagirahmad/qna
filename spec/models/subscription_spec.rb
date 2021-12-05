# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  subject { build(:subscription, user: create(:user), subscribeable: create(:question)) }

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :subscribeable }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:subscribeable_type, :subscribeable_id) }
end
