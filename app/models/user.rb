# An application user, uses the `devise` library
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # https://github.com/heartcombo/devise/wiki/
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # The dependent: option allows to specify that associated records should be deleted when the owner is deleted
  # https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html >> Deleting from Associations
  has_many :notes, dependent: :delete_all
  has_and_belongs_to_many :contacts,
                          class_name: "User",
                          foreign_key: "user_id",
                          association_foreign_key: "contact_id"
end
