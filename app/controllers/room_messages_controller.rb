class RoomMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room_message = RoomMessage.new(room_message_params)
    if @room_message.save
      RoomChannel.broadcast_to @room, @room_message
    else
      redirect_to root_path, alert: I18n.t('denial.resource_creation', resource: RoomMessage)
    end
  end

  protected

  # Only allow a trusted parameter "white list" through.
  def room_message_params
    @room = Room.find(params[:room_message][:room_id])

    params.require(:room_message)
          .permit(:message, :room_id)
          .merge(user: current_user,
                 room: @room)
  end
end
