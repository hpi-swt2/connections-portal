# A class for handling contacts, when one contact is created the other way is too
class Friendship < ApplicationRecord
  self.table_name = 'users_users'
  belongs_to :user, foreign_key: :contact_id, inverse_of: :friendships

  after_create do |c|
    Friendship.create!(user_id: c.contact_id, contact_id: c.user_id) unless Friendship.find_by(contact_id: c.user_id)
  end

after_destroy do |c|
  reciprocal = Friendship.find_by(contact_id: c.user_id)
  reciprocal&.destroy
end
end
