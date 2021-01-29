# A chat message in a room
class RoomMessage < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :room, inverse_of: :room_messages
  belongs_to :user

  validates :message, presence: true

  def formatted_time
    created_at.strftime('%Y-%m-%d %H:%M')
  end

  def as_json(options = nil)
    super(options).merge(
      display_name: user.display_name,
      send_date: formatted_time,
      user_link: user_path(user)
    )
  end
end
