class Friendship < ApplicationRecord
  self.table_name = "users_users"
  belongs_to :user, :foreign_key => :contact_id

  after_create do |c|
    unless Friendship.find_by(contact_id: c.user_id)
      Friendship.create!(:user_id => c.contact_id, :contact_id => c.user_id)
    end
  end

  after_destroy do |c|
    reciprocal = Friendship.find_by(contact_id: c.user_id)
    reciprocal.destroy unless reciprocal.nil?
  end
end
