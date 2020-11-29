class TagsController < ApplicationController
  before_action :set_tag, only: %i[show edit update destroy]

  # GET /tags
  def index
    @tags = Tag.all
  end

  # GET /tags/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tag
    @tag = Tag.find params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def tag_params
    params.require(:tag).permit :name
  end
end
