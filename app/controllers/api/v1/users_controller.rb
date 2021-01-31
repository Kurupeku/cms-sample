# frozen_string_literal: true

module Api
  module V1
    # api/v1/users
    class UsersController < ApplicationControllerCustomized
      before_action :authenticate_api_v1_user!

      private

      def initialize_controller
        @permitted_params = %i[email password]
        @export_params = %i[id email created_at updated_at deleted_at]
        @serializer = UserSerializer
      end
    end
  end
end
