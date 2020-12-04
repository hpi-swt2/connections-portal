class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def update_status
    @user = User.find(params[:id])
    @user.current_status = params[:user][:current_status]
    @user.save
    redirect_to @user
  end
end
