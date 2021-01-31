# frozen_string_literal: true

module Api
  module V1
    # api/v1/users
    class ArticlesController < ApplicationControllerCustomized
      before_action :authenticate_api_v1_user!

      private

      def initialize_controller
        @permitted_params = %i[
          slug author_id category_id status cover article_type title content
          opening_sentence published_at
        ]
        @relation_params = %i[comments tags]
        @serializer = ArticleSerializer
      end
    end
  end
end
