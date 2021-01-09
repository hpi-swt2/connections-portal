class HomeController < ApplicationController
  before_action :filter_users_status

  def dashboard
    if user_signed_in?
      render 'dashboard'
    else
      render 'index'
    end
  end

  def filter_users_status
    @status_filter = User.default_status_filter
    @status_filter = params[:filter_status] if User.filter_status_list.include?(params[:filter_status])

    @users = User.with_status(@status_filter)
    @users = @users.shuffle
  end
end
