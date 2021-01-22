# A chat message in a room
class RoomMessage < ApplicationRecord
  belongs_to :room, inverse_of: :room_messages
  belongs_to :user

  validates :message, presence: true

  def formatted_time
    created_at.strftime('%Y-%m-%d %H:%M')
  end

  def as_json(options = nil)
    super(options).merge(username: user.username)
  end
end
