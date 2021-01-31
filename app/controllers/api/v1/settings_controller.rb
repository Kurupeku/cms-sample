# frozen_string_literal: true

module Api
  module V1
    # api/v1/users
    class SettingsController < ApplicationControllerCustomized
      before_action :authenticate_api_v1_user!

      def index; end

      def create; end

      def destroy; end

      private

      def initialize_controller
        @permitted_params = %i[
          site_title mail_to main_cover anable_main_cover anable_recent_comments
          anable_recent_popular recent_popular_span
        ]
        @serializer = SettingSerializer
      end

      def set_model
        @model = Setting.first
      end
    end
  end
end
