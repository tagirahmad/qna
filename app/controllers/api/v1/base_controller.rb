# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!
      protect_from_forgery with: :null_session

      private

      def current_user
        @current_user ||= User.find(doorkeeper_token.resource_owner_id)
      end
    end
  end
end
