# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscribeable, only: :create
  before_action :set_subscription,  only: :destroy

  authorize_resource

  def create
    @subscribeable.subscriptions.create!(user_id: current_user.id)
  end

  def destroy
    @subscription.destroy
  end

  private

  def set_subscribeable
    subscribeable_type = params[:subscribeable_type]
    subscribeable_id   = params[:subscribeable_id]

    @subscribeable = ActiveSupport::Dependencies.constantize(subscribeable_type.capitalize)
                                                .find(subscribeable_id)
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
