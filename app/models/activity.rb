# A model for storing activities, composed of text, for a user
class Activity < ApplicationRecord
  validates :content, presence: true
  validates :user, presence: true

  belongs_to :user
end
