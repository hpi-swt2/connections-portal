class AddContactsToUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :contact
    end
  end
end
