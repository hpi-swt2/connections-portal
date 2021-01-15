class AddGlobalChat < ActiveRecord::Migration[6.0]
  def up
    Room.create name: 'Global Chat', id: Room::GLOBAL_CHAT_ID
  end

  def down
    Room.delete_by id: Room::GLOBAL_CHAT_ID
  end

end
