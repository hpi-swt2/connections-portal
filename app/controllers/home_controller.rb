class HomeController < ApplicationController
  def dashboard
    if user_signed_in?
      filter_users_status
      @room_messages = Room.find(Room::GLOBAL_CHAT_ID).room_messages
      render 'dashboard'
    else
      render 'index'
    end
  end

  def filter_users_status
    @users = User.where.not(id: current_user.id).with_status(User.filter_status)
    @users = @users.sample(maximum_length_user_list)
  end

  private

  def maximum_length_user_list
    30
  end
end
