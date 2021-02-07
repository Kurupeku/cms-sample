# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module Api
  module V1
    # Format on CRUD controller
    class ApplicationControllerCustomized < ApplicationController
      include DeviseTokenAuth::Concerns::SetUserByToken
      include ParameterConversion
      include CsvProcessing

      skip_forgery_protection

      prepend_before_action :initialize_variant
      prepend_before_action :paginate_params, only: [:index]
      before_action :set_model, only: %i[show update destroy]
      before_action :search_records, only: [:index]

      # GET /api/v1/models
      def index
        # render json: @models
        render json: serialized_records
      end

      # GET /api/v1/models/1
      def show
        # render json: @model
        render json: serialized_record
      end

      # POST /api/v1/models
      def create
        @model = @active_model.new model_params

        if @model.save
          render json: serialized_record,
                 status: :created,
                 location: self_url(@model)
        else
          invalid_json
        end
      end

      # PATCH/PUT /api/v1/models/1
      def update
        if @model.update model_params
          head :no_content
        else
          invalid_json
        end
      end

      # DELETE /api/v1/models/1
      def destroy
        head :no_content
      end

      def import
        if params[:csv].present?
          result = import_records params[:csv]
          error_data = result.filter { |r| r[:status] == :error }
          render json: { errors: error_data }.to_json
        else
          render json: { errors: [
            I18n.t('response.errors.attachment_not_exist')
          ] }, status: :bad_request
        end
      end

      def export
        today_str = Time.current.strftime '%Y%m%d%H%M%S'
        filename = "#{today_str}_#{@model_name.underscore}.csv"
        send_data export_records, filename: filename,
                                  type: :csv
      end

      def export_template
        filename = 'import_template.csv'
        send_data import_template, filename: filename,
                                   type: :csv
      end

      private

      # Set Model and Serializer to variable
      def initialize_controller
        # @model_name # = define ActiveModel name by String object
        # @active_model # = ActiveModel class object
        # @permitted_params # = permit attribute symbols for action create and update
        # @export_params # = export attribute sympols in generate csv file
        # @relation_params # = define symbol array for ActiveModel.includes
        # @serializer # define Serializer of fast_jsonapi
      end

      def initialize_variant
        initialize_controller
        @model_name ||= controller_name.classify
        @active_model ||= @model_name.constantize
        @permitted_params ||= @active_model.attribute_names.map(&:to_sym)
        @export_params ||= @active_model.attribute_names.map(&:to_sym)
        @relation_params ||= []
        @serializer ||= nil
      end

      def serialized_records
        if @serializer.present?
          options = serialize_options.merge({ is_collection: true })
          hash = @serializer.new(@models, options).serializable_hash
          { **hash, pagination: pagination_info }.to_json
        else
          @models.to_json
        end
      end

      def serialized_record
        if @serializer.present?
          @serializer.new(@model, serialize_options).serialized_json
        else
          @models.to_json
        end
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_model
        @model = @active_model.find_by id: params[:id]
        render(json: not_found, status: :not_found) unless @model.present?
      end

      def search_relations
        return @active_model unless @relation_params&.size&.positive?

        @active_model.includes(*@relation_params)
      end

      def search_records
        ransack = search_relations.ransack(search_params)
        @models = ransack.result.page(@page).per(@per)
        pagination_info
      end

      # Only allow a trusted parameter "white list" through.
      def model_params
        snakalize_keys params.require(model_symbol)
                             .permit(*@permitted_params)
                             .to_h
      end

      def search_params
        query_params = snakalize_keys(params[:q]&.permit!&.to_h || {})
        convert_ransack_params query_params
      end

      def serialize_options
        snakalize_keys({
                         include: params[:include],
                         fields: params[:fields],
                       })
      end

      def model_symbol
        @model_name.underscore.to_sym
      end

      def paginate_params
        @page = params[:page]&.to_i || 1
        @per = params[:per]&.to_i || 25
      end

      def invalid_json
        render json: { errors: @model.errors.full_messages },
               status: :unprocessable_entity
      end

      def self_url(model)
        "#{root_url}api/v1/#{@model_name.underscore.pluralize}/#{model.id}"
      end

      def pagination_info
        {
          current: @models.current_page,
          previous: @models.prev_page,
          next: @models.next_page,
          per: @models.limit_value,
          pages: @models.total_pages,
          count: @models.total_count
        }
      end

      def not_found
        {
          errors: [
            I18n.t('response.errors.not_found')
          ]
        }.to_json
      end

      def set_setting; end

      def define_menu_variables; end

      def static_page_menus; end

      def define_side_menu_models; end
    end
  end
end
