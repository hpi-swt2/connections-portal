class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def update_status

  end
end
