# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController
      authorize_resource class: User

      def me
        render json: current_user
      end

      def index
        render json: User.where.not(id: current_user.id)
      end
    end
  end
end
