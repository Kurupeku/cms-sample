# frozen_string_literal: true

module Api
  module V1
    # api/v1/users
    class ProfilesController < ApplicationControllerCustomized
      before_action :authenticate_api_v1_user!

      def index; end

      def create; end

      def destroy; end

      private

      def initialize_controller
        @permitted_params = %i[user_id name description avatar]
        @serializer = ProfileSerializer
      end

      def set_model
        @model = User.find(params[:user_id]).profile
      end
    end
  end
end
