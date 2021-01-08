class AddContactRequestsToUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users_contact_requests, id: false do |t|
      t.belongs_to :requested_user
      t.belongs_to :requesting_user

      t.timestamps
    end
  end
end
