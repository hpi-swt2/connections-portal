class HomeController < ApplicationController
  def dashboard
    if user_signed_in?
      filter_users_status
      render 'dashboard'
    else
      render 'index'
    end
  end

  def filter_users_status
    @users = User.where.not(id: current_user.id).with_status(User.status_nice_to_meet_you)
    @users = @users.sample(30)
  end
end
