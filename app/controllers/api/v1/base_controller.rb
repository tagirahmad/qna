module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!
      protect_from_forgery with: :null_session

      private

      def current_user
        if doorkeeper_token
          @current_user || User.find(doorkeeper_token.resource_owner_id)
        else
          warden.authenticate(scope: :user)
        end
      end
    end
  end
end
