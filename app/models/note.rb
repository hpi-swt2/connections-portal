# A model for storing text connected to a user
class Note < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :user, presence: true
  validates :creator_user, presence: true

  belongs_to :user
  belongs_to :creator_user, class_name: 'User'
end
