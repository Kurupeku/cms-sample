# frozen_string_literal: true

module Api
  module V1
    # api/v1/users
    class CategoriesController < ApplicationControllerCustomized
      before_action :authenticate_api_v1_user!

      private

      def initialize_controller
        @permitted_params = %i[parent_id name]
        @relation_params = %i[articles]
        @serializer = CategorySerializer
      end
    end
  end
end
