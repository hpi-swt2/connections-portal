class AddJitsiCalls < ActiveRecord::Migration[6.0]
  def change
    create_table :jitsi_calls do |t|
      t.string :room_name

      t.timestamps
    end

    create_join_table :users, :jitsi_calls, table_name: :call_participants do |t|
      t.string :role
      t.string :state

      t.timestamps
    end
  end
end
