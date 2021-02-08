class HomeController < ApplicationController
  def dashboard
    if user_signed_in?
      filter_users_status
      @room_messages = Room.global_chat_room.room_messages
      render 'dashboard'
    else
      render 'index'
    end
  end

  def filter_users_status
    @users = User.where.not(id: current_user.id).with_status(User.filter_status)
    @users = @users.sample(MAXIMUM_LENGTH_USER_LIST)
  end

  def chat
    if user_signed_in?
      @room_messages = Room.global_chat_room.room_messages
      render 'home/chat_page'
    else
      render 'index'
    end
  end

  MAXIMUM_LENGTH_USER_LIST = 4
end
