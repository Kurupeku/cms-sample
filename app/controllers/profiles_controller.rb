class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show]

  # GET /profiles
  def index
    @profiles = Profile.all
  end

  # GET /profiles/1
  def show; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find params[:id]
  end

  # Only allow a trusted parameter "white list" through.
  def profile_params
    params.require(:profile).permit :user_id, :name, :description, :avatar
  end
end
