# A class for handling contacts which ensures that the association is always symmetrical
class Friendship < ApplicationRecord
  self.table_name = 'users_users'
  self.primary_keys = :user_id, :contact_id

  belongs_to :user, inverse_of: :friendships
  belongs_to :contact, class_name: 'User', inverse_of: :friendships

  after_create do |c|
    unless Friendship.find_by(user_id: c.contact_id, contact_id: c.user_id)
      Friendship.create(user_id: c.contact_id, contact_id: c.user_id)
    end
  end

  after_destroy do |c|
    reciprocal = Friendship.find_by(contact_id: c.user_id, user_id: c.contact_id)
    reciprocal&.destroy
  end
end
