class UsersController < ApplicationController
  # GET /users

  def index
    @users = User.all
  end

  def add_contact
    current_user.contacts << User.find(params[:id])
    current_user.save
    redirect_to home_index_path
  end

end
