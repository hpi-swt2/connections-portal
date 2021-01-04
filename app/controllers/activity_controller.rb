class ActivityController < ApplicationController
  # POST /activity
  def create
    @activity = Activity.new({content: activity_params[:content], user: User.find(activity_params[:user])})

    unless @activity.save
      # TODO: Error Handling
    end
  end

  private # Everything below this line is private

  # Only allow a trusted parameter "white list" through.
  def activity_params
    params.require(:activity).permit(:content, :user)
  end
end
