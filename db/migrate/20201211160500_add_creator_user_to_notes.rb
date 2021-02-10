class AddCreatorUserToNotes < ActiveRecord::Migration[6.0]
  def change
    Note.connection.execute('DELETE FROM notes')
    add_reference :notes, :creator_user, default: '', foreign_key: { to_table: :users }
    change_column_null :notes, :creator_user_id, false
  end
end
