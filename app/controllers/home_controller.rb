class HomeController < ApplicationController
  before_action :authorize

  def dashboard
    filter_users_status
    @room_messages = Room.global_chat_room.room_messages
    render 'dashboard'
  end

  def chat
    @room_messages = Room.global_chat_room.room_messages
    render 'home/chat_page'
  end

  private

  def authorize
    return render 'index' unless user_signed_in?
  end

  def filter_users_status
    @users = User.where.not(id: current_user.id).with_status(User.filter_status)
    @users = @users.sample(MAXIMUM_LENGTH_USER_LIST)
  end

  MAXIMUM_LENGTH_USER_LIST = 4
end
