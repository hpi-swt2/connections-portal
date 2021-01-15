class RoomMessage < ApplicationRecord
  belongs_to :room, inverse_of: :room_messages
  belongs_to :user

  validates :message, presence: true

  def as_json(options = nil)
    super(options).merge(username: user.username)
  end
end
