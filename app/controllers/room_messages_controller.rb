class RoomMessagesController < ApplicationController

  def create
    @room_message = RoomMessage.new(room_message_params)
    if @room_message.save
      RoomChannel.broadcast_to @room, @room_message
      respond_to do |format|
        return format.js
      end
    end

    redirect_to root_path, alert: I18n.t('denial.resource_creation', resource: RoomMessage)
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
