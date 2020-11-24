class Note < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :user, presence: true

  belongs_to :user
end
