class AddCurrentStatusToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_status, :string
  end
end
