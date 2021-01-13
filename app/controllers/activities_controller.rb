class ActivitiesController < ApplicationController
  before_action :authenticate_user!

  # POST /activity
  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      respond_to do |format|
        return format.js
      end
    end

    redirect_to root_path, alert: I18n.t('denial.resource_creation', resource: Activity)
  end

  private # Everything below this line is private

  # Only allow a trusted parameter "white list" through.
  def activity_params
    params.require(:activity).permit(:content).merge(user: current_user)
  end
end
