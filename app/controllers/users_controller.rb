class UsersController < ApplicationController
  before_action :set_user, only: %i[show update_status]

  def show; end

  def update_status
    return redirect_to root_path unless user_is_current_user?

    @user.current_status = params[:user][:current_status]
    @user.save
    redirect_to @user
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_is_current_user?
    user_signed_in? && current_user.id.to_s == params[:id]
  end
end
