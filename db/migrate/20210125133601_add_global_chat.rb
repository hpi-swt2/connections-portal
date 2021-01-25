class AddGlobalChat < ActiveRecord::Migration[6.0]
  def up
    Room.create name: 'Global Chat', id: Room::GLOBAL_CHAT_ID
  end

  def down
    # sometimes dependent: destroy does not work, so make sure we delete all messages first
    RoomMessage.delete_by room_id: Room::GLOBAL_CHAT_ID
    Room.delete_by id: Room::GLOBAL_CHAT_ID
  end
end
