# frozen_string_literal: true

module Api
  module V1
    # api/v1/users
    class CommentsController < ApplicationControllerCustomized
      before_action :authenticate_api_v1_user!

      private

      def initialize_controller
        @permitted_params = %i[
          user_id parent_id article_id status number author_name content
        ]
        @serializer = CommentSerializer
      end
    end
  end
end
