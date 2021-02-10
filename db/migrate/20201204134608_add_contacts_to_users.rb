class AddContactsToUsers < ActiveRecord::Migration[6.0]
  # This migration runs already in production so I do not want to tamper with it
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    create_table :users_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :contact
    end
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
