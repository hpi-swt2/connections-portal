class HomeController < ApplicationController
  def dashboard
    @users = User.all
    if user_signed_in?
      @room_messages = Room.find(Room::GLOBAL_CHAT_ID).room_messages
      render 'dashboard'
    else
      render 'index'
    end
  end
end
