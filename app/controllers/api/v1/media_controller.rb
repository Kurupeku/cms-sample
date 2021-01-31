# frozen_string_literal: true

module Api
  module V1
    # api/v1/users
    class MediaController < ApplicationControllerCustomized
      before_action :authenticate_api_v1_user!

      private

      def initialize_controller
        @permitted_params = %i[file]
        @serializer = MediumSerializer
      end
    end
  end
end
