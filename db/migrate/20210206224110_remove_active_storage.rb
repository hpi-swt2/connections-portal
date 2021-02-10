class RemoveActiveStorage < ActiveRecord::Migration[6.0]
  def up
    drop_table :active_storage_attachments
    drop_table :active_storage_blobs
  end

  def down
    create_table :active_storage_blobs, &:timestamps
    create_table :active_storage_attachments, &:timestamps
  end
end
