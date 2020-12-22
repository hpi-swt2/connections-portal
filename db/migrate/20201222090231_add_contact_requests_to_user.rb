class AddContactRequestsToUser < ActiveRecord::Migration[6.0]
  def change
    create_table :users_contact_requests, id: false do |t|
      t.belongs_to :user
      t.belongs_to :contact_request
    end
  end
end
