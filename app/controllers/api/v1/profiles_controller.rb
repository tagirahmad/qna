# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      def me
        render json: current_resource_owner
      end

      def index
        render json: User.where.not(id: current_resource_owner.id)
      end
    end
  end
end
