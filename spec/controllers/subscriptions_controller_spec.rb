# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user)        { create :user }
  let(:second_user) { create :user }
  let(:question)    { create :question }

  let(:create_subscription) do
    post :create, params: { subscribeable_type: question.class.to_s, subscribeable_id: question.id }, format: :js
  end

  before { login user }

  describe '#POST create' do
    it 'creates a new subscription' do
      expect { create_subscription }.to change(Subscription, :count).by 1
    end
  end

  describe '#DELETE destroy' do
    let!(:subscription) { create :subscription, user: user, subscribeable: question }

    let(:delete_subscription) do
      delete :destroy, params: { id: subscription }, format: :js
    end

    it 'deletes subscription' do
      expect { delete_subscription }.to change(Subscription, :count).by(-1)
    end

    it 'non-author can not delete subscription' do
      login second_user
      expect { delete_subscription }.to change(Subscription, :count).by 0
    end
  end
end
